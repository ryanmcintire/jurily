import React, {PropTypes} from 'react';
import Superagent from 'superagent';

import RichTextEditor from './RichTextEditor';
import QuestionTags from './QuestionTags';

export default class QuestionForm extends React.Component {

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
    this.state = {
      editorValue: props.initialEditorValue,
      submitRequired: false,
      submitting: false,
      title: props.initialTitle,
      jurisdictionSelectValue: props.currentJurisdiction || 'None Specified',
      errors: [],
      tags: []
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
    return {
      title: this.state.title,
      body: this.state.editorValue,
      user: this.props.user,
      jurisdiction: this.state.jurisdictionSelectValue,
      tags: this.state.tags
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
    this.setState({errors: []});
    window.location.href = res.forwardingUrl
  }

  handleSubmitError(err) {
    //todo - get path constants
    console.log('Error!');
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
    console.log('Attempting to add error to state', message);
    //todo - robustify addErrorToSTate.
    this.setState({
      errors: [message]
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

  addTags(tags) {
    this.setState({tags});
  }

  //todo - render errors outside of the box?
  render() {
    return (
      <div>
        <div className="page-header">
          <h3>Ask Question</h3>
        </div>
        {this.renderErrors()}
        <div>
          <form>
            <div className="form-group">
              <label>Question Title: </label>
              <input
                type="text"
                id="questionTitle"
                placeholder="What is your question?  Be concise and specific."
                value={this.state.title}
                onChange={this.handleTitleChange.bind(this)}
                className="form-control"
              />
            </div>
            <div className="form-group">
              <label htmlFor="jurisdiction">Jurisdiction: </label>
              <select id="jurisdiction"
                      value={this.state.jurisdictionSelectValue}
                      onChange={this.handleSelectChange.bind(this)}
                      className="form-control">
                {
                  this.props.jurisdictionOptions.map((jdx) => {
                    return (
                      <option value={jdx}>{jdx}</option>
                    );
                  })
                }
              </select>
            </div>
            <div className="form-group">
              <label>Tags: </label>
              <br />
              <QuestionTags addTags={this.addTags.bind(this)} />
            </div>
            <br />
            <div className="form-group">
              <label htmlFor="question-editor">Question Detail:</label>
              {this.renderEditor()}
            </div>
            <div className="row">
              <div className="col-md-3 col-md-offset-10">
                <button
                  className="btn btn-primary rich-text-editor-submit"
                  onClick={this.handleSubmitClick.bind(this)}>Submit
                </button>
              </div>
            </div>
          </form>
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

