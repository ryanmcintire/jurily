import React, {PropTypes} from 'react';
import Superagent from 'superagent';

import RichTextEditor from './RichTextEditor';

export default class RichTextEditorQuestionForm extends React.Component {

  static propTypes = {
    user: PropTypes.string.isRequired,
    hostUrl: PropTypes.string.isRequired,
    initialTitle: PropTypes.string.isRequired,
    initialEditorValue: PropTypes.string.isRequired,
    csrfToken: PropTypes.string.isRequired
  };

  constructor(props, ctx) {
    super(props, ctx);
    this.state = {
      editorValue: props.initialEditorValue,
      submitRequired: false,
      submitting: false,
      titleValue: props.initialTitle,
      errors: []
    }
  }

  toggleSubmitRequired() {
    this.setState({submitRequired:!this.state.submitRequired});
  }

  toggleSubmitting() {
    this.setState({submitting:!this.state.submitting});
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
        this.setState({})
        if (err || !res.ok) this.handleSubmitError(err);
        else this.handleSubmitSuccess(res);
      });
  }

  getDataForSubmit() {
    return {
      title: this.state.title,
      text: this.state.editorValue,
      user: this.props.user
    }
  }

  handleSubmitSuccess(res) {
    //todo - need to figure out what response body looks like.
    console.log(res);
  }

  handleSubmitError(err) {
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
      <div className="container">
        <div className="row">
          {this.renderErrors()}
        </div>
        <div className="row">
          <div className="well">
            Will need to put title here...
          </div>
        </div>
        <div className="row">
          <div className="text-editor-question">
            <RichTextEditor
              editorSubmitAction={this.editorSubmitAction.bind(this)}
              submitting={this.state.submitting}
            />
          </div>
        </div>
        <div className="row">
          <button className="btn btn-default" onClick={this.handleSubmitClick.bind(this)}>Submit</button>
        </div>
      </div>
    )
  }

  renderErrors() {
    return (
      <div>
        Errors to go here...
      </div>
    )
  }
}
