import React, {PropTypes} from 'react';
import Superagent from 'superagent';

import RichTextEditor from './RichTextEditor';

export default class RichTextEditorForm extends React.Component {

  static propTypes = {
    user: PropTypes.object,
    hostUrl: PropTypes.string.isRequired,
    initialTitle: PropTypes.string.isRequired,
    initialEditorValue: PropTypes.string.isRequired,
    csrfToken: PropTypes.string.isRequired,
    isQuestion: PropTypes.bool.isRequired,
    questionId: PropTypes.string,
    baseClassName: PropTypes.string.isRequired,
    editorClassName: PropTypes.string.isRequired,
    toolbarClassName: PropTypes.string.isRequired,
    jurisdictionOptions: PropTypes.array
    //todo - add proptype for jurisdictions.
  };

  constructor(props, ctx) {
    super(props, ctx);
    this.state = {
      editorValue: props.initialEditorValue,
      submitRequired: false,
      submitting: false,
      title: props.initialTitle,
      jurisdictionSelectValue: 'Select',
      errors: []
    }
  }

  toggleSubmitRequired() {
    this.setState({submitRequired: !this.state.submitRequired});
  }

  toggleSubmitting() {
    this.setState({submitting: !this.state.submitting});
  }

  componentDidUpdate(prevProps, prevState) {
    if (this.state.submitRequired) {
      this.submitEditorTextToServer();
    }
  }

  submitEditorTextToServer() {
    this.toggleSubmitRequired();
    Superagent
      .post(this.props.hostUrl)
      .send(this.getDataForSubmit())
      .set('X-CSRF-Token', this.props.csrfToken)
      .set('Accept', 'application/json')
      .end((err, res) => {
        if (err || !res.ok) this.handleSubmitError(err);
        else this.handleSubmitSuccess(res);
      });
  }

  getDataForSubmit() {
    if (this.props.isQuestion == true) return this.questionSubmitData();
    return this.answerSubmitData();
  }

  questionSubmitData() {
    //todo - need to handle if data is not here properly.  
    return {
      title: this.state.title,
      body: this.state.editorValue,
      user: this.props.user,
      jurisdiction: this.state.jurisdictionSelectValue
    }
  }

  answerSubmitData() {
    return {
      body: this.state.editorValue,
      user: this.props.user,
      questionId: this.props.questionId
    }
  }

  handleSubmitSuccess(res) {
    res = JSON.parse(res.text);
    //todo - need to figure out what response body looks like.
    console.log(res);
    window.location.href = res.forwardingUrl;
  }

  handleSubmitError(err) {
    //todo - get path constants
    if (err.status == 401) {
      window.location.href = 'https://' + window.location + "/users/sign_in";
    }
    //todo - handle submit error
    console.log(err);
  }

  editorSubmitAction(editorValue) {
    this.toggleSubmitting();
    this.toggleSubmitRequired();
    this.setState({editorValue});
  }

  handleSelectChange(e) {
    this.setState({
      jurisdictionSelectValue:e.target.value
    });
  }

  handleSubmitClick(e) {
    e.preventDefault();
    if (!this.props.user) {
      window.location.href = `https://${window.location.host}/users/sign_in`;
      return;
    }
    if (this.props.user) {
      this.toggleSubmitting();
    }
    this.toggleSubmitting();
  }

  render() {
    return (
      <div className="container col-md-12">
        <div className="row">
          {this.renderErrors()}
        </div>
        <div className="row">
          {this.renderTitle()}
        </div>
        <div>
          {this.renderJurisdictionDropdown()}
        </div>
        <div className="row">
          {this.renderEditor()}
        </div>
        <div className="row">
          <div className="container">
            <button
              className="btn btn-primary rich-text-editor-submit"
              onClick={this.handleSubmitClick.bind(this)}>Submit
            </button>
          </div>
        </div>
      </div>
    )
  }

  renderErrors() {
    if (this.state.errors.length > 0) {
      return (
        <div className="alert alert-danger">
          {this.state.errors}
        </div>
      )
    }
  }

  handleTitleChange(e) {
    this.setState({title: e.target.value});
  }

  renderTitle() {
    if (this.props.isQuestion) return (
      <form className="form-horizontal question-title">
        <div className="form-group">
          <label htmlFor="questionTitle" className="col-md-3 control-label form-input-label">Question Title:</label>
          <div className="col-md-9">
            <input
              type="text"
              className="form-control"
              id="questionTitle"
              placeholder="What is your question?  Be concise and specific."
              value={this.state.title}
              onChange={this.handleTitleChange.bind(this)}
            />
          </div>
        </div>
      </form>
    )
  }

  renderJurisdictionDropdown() {
    if (this.props.isQuestion) return (
      <form className="form-horizontal question-jurisdiction-dropdown">
        <div className="form-group">
          <label htmlFor="jurisdiction" className="col-md-3 control-label form-input-label">Jurisdiction: </label>
          <div className="col-md-9">
            <select className="form-control"
                    value={this.state.jurisdictionSelectValue}
                    onChange={this.handleSelectChange.bind(this)}>
              {
                this.props.jurisdictionOptions.map((jdx) => {
                  return (
                    <option value={jdx}>{jdx}</option>
                  );
                })
              }
            </select>
          </div>
        </div>
      </form>
    )
  }

  renderEditor() {
    return (
      <div className="form-group text-editor-form-group">
        <RichTextEditor
          editorSubmitAction={this.editorSubmitAction.bind(this)}
          submitting={this.state.submitting}
          baseClassName={this.props.baseClassName}
          editorClassName={this.props.editorClassName}
          toolbarClassName={this.props.toolbarClassName}
          placeholder={this.getPlaceholder()}
        />
      </div>
    )
  }

  getPlaceholder() {
    if (this.props.isQuestion) return "Type further question details here...";
    return "Type answer here...";
  }
}
