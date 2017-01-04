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
    currentJurisdiction: PropTypes.string,
    jurisdictionOptions: PropTypes.array,
    update: PropTypes.bool
    //todo - add proptype for jurisdictions.
  };

  constructor(props, ctx) {
    super(props, ctx);
    console.log(props.initialEditorValue);
    this.state = {
      editorValue: props.initialEditorValue,
      submitRequired: false,
      submitting: false,
      title: props.initialTitle,
      jurisdictionSelectValue: props.currentJurisdiction || 'None Specified',
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
    if (this.props.isUpdate) this.submitUpdateText();
    else this.submitNewText();
  }

  submitUpdateText() {
    Superagent
      .put(this.props.hostUrl)
      .send(this.getDataForSubmit())
      .set('X-CSRF-Token', this.props.csrfToken)
      .set('Accept', 'application/json')
      .end((err, res) => {
        if (err || !res.ok) this.handleSubmitError(err);
        else this.handleSubmitSuccess(res);
      });
  }

  submitNewText() {
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
    console.log('and look here!');
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
    this.setState({errors:[]});
    window.location.href = res.forwardingUrl
  }

  handleSubmitError(err) {
    //todo - get path constants
    if (err.status == 401) {
      window.location.href = "/users/sign_in";
    }
    if (err.status == 400 &&
      err.response &&
      err.response.body &&
      err.response.body.message) {
        this.addErrorToState(err.response.body.message);
    }
  }

  addErrorToState(message) {
    //todo - robustify addErrorToSTate.
    this.setState({
      errors:[message]
    })
  }

  editorSubmitAction(editorValue) {
    this.toggleSubmitting();
    this.toggleSubmitRequired();
    this.setState({editorValue});
  }

  handleSelectChange(e) {
    console.log('look here!');
    this.setState({
      jurisdictionSelectValue: e.target.value
    });
  }

  handleSubmitClick() {
    this.toggleSubmitting();
  }

  //todo - render errors outside of the box?
  render() {
    return (
      <div className="content-box">
        <div className="content-box-title">
          Ask Question
        </div>
        {this.renderErrors()}
        <div>
          <form className="form-style-1">
            <p className="form-layer">
              <label>Question Title: </label>
              <input
                type="text"
                id="questionTitle"
                placeholder="What is your question?  Be concise and specific."
                value={this.state.title}
                onChange={this.handleTitleChange.bind(this)}
              />
            </p>
            <p className="form-layer">
              <label>Jurisdiction: </label>
              <select value={this.state.jurisdictionSelectValue}
                      onChange={this.handleSelectChange.bind(this)}>
                {
                  this.props.jurisdictionOptions.map((jdx) => {
                    return (
                      <option value={jdx}>{jdx}</option>
                    );
                  })
                }
              </select>
            </p>
          </form>
          <p className="form-layer">
            {this.renderEditor()}
          </p>
          <div className="row">
            <div className="container">
              <button
                className="btn btn-primary rich-text-editor-submit"
                onClick={this.handleSubmitClick.bind(this)}>Submit
              </button>
            </div>
          </div>
        </div>
      </div>
    )
  }

  renderErrors() {
    if (this.state.errors.length > 0) {
      console.log('errors should be here...');
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
      <div className="form-group">
        <label htmlFor="questionTitle" className="control-label col-sm-2 form-input-label">Question Title:</label>
        <input
          type="text"
          className="form-control col-sm-6"
          id="questionTitle"
          placeholder="What is your question?  Be concise and specific."
          value={this.state.title}
          onChange={this.handleTitleChange.bind(this)}
        />
      </div>
    )
  }

  renderJurisdictionDropdown() {
    if (this.props.isQuestion) return (
      <div className="form-group">
        <label htmlFor="jurisdiction" className="control-label col-sm-2 form-input-label">Jurisdiction: </label>

        <select value={this.state.jurisdictionSelectValue}
                onChange={this.handleSelectChange.bind(this)}>
          <option>Select One</option>
          {
            this.props.jurisdictionOptions.map((jdx) => {
              return (
                <option value={jdx}>{jdx}</option>
              );
            })
          }
        </select>
      </div>
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
          initialEditorValue={this.props.initialEditorValue}
        />
      </div>
    )
  }

  getPlaceholder() {
    if (this.props.isQuestion) return "Type further question details here...";
    return "Type answer here...";
  }
}

