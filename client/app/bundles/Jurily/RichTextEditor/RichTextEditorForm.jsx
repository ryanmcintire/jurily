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
    isQuestion: PropTypes.bool.isRequired
  };

  constructor(props, ctx) {
    super(props, ctx);
    this.state = {
      editorValue: props.initialEditorValue,
      submitRequired: false,
      submitting: false,
      title: props.initialTitle,
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
    console.log(this.questionSubmitData());
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
    return {
      title: this.state.title,
      body: this.state.editorValue,
      user: this.props.user
    }
  }

  answerSubmitData() {
    return {
      body: this.state.editorValue,
      user: this.props.user
    }
  }

  handleSubmitSuccess(res) {
    res = JSON.parse(res.text);
    //todo - need to figure out what response body looks like.
    console.log(res);
    window.location.href = res.forwardingUrl
  }

  handleSubmitError(err) {
    //todo - get path constants
    if (err.status == 401) {
      window.location.href = "/users/sign_in";
    }
    //todo - handle submit error
    console.log(err);
  }

  editorSubmitAction(editorValue) {
    this.toggleSubmitting();
    this.toggleSubmitRequired();
    this.setState({editorValue});
  }

  handleSubmitClick() {
    this.toggleSubmitting();
  }

  render() {
    return (
      <div className="container rich-text-editor-container">
        <div className="row">
          {this.renderErrors()}
        </div>
        <div className="row">
          {this.renderTitle()}
        </div>
        <div className="row">
          {this.renderEditor()}
        </div>
        <div className="row">
          <button
            className="btn btn-primary rich-text-editor-submit"
            onClick={this.handleSubmitClick.bind(this)}>Submit</button>
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
    this.setState({title:e.target.value});
  }

  renderTitle() {
    if (this.props.isQuestion) return (
      <div className="container">
        <div className="form-group">
          <label htmlFor="questionTitle">Question Title:</label>
          <input
            type="text"
            className="form-control"
            id="questionTitle"
            placeholder="Question Title"
            value={this.state.title}
            onChange={this.handleTitleChange.bind(this)}
          />
        </div>
      </div>
    )
  }

  renderEditor() {
    return (
      <div className="text-editor-question">
        <RichTextEditor
          editorSubmitAction={this.editorSubmitAction.bind(this)}
          submitting={this.state.submitting}
        />
      </div>
    )
  }
}
