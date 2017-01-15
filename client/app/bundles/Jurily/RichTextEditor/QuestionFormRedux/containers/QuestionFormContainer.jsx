import React from 'react';
import {connect} from 'react-redux';
import {bindActionCreators} from 'redux';

import QuestionTags from '../../QuestionTags';
import RichTextEditor from './RichTextEditor';

import {submitForm} from '../actions/actions';

class QuestionFormContainer extends React.Component {

  constructor(props, ctx) {
    super(props, ctx);
    console.log(props.question.tags);
    console.log(props.question);
    this.state = {
      form: {
        jurisdiction: (props.question && props.question.jurisdiction) ? props.question.jurisdiction : 'None Specified',
        tags: (props.question && props.question.tags) ? props.question.tags : [],
        title: (props.question && props.question.title) ? props.question.title : '',
        body: (props.question && props.question.body) ? props.question.body : ''
      }
    };
    this.onEditorChange = this.onEditorChange.bind(this);
  }

  onEditorChange(value) {
    this.setState({
      form: {
        ...this.state.form,
        body: value
      }
    });
  }

  handleChange(e) {
    let form = this.state.form;
    form[e.target.id] = e.target.value;
    this.setState({form});
  }

  handleSubmitClick(e) {
    e.preventDefault();
    //todo - add validation.
    //todo - validation should check both form fields and whether there is a user.
    this.props.submitForm(this.getSubmitData());
  }

  getSubmitData() {
    const {csrfToken, question} = this.props;
    return {
      form: this.state.form,
      csrfToken,
      question
    };
  }


  addTags(tags) {
    this.setState({form: Object.assign({}, this.state.form, {tags})});
    // let form = this.state.form;
    // form.tags = tags;
    // this.setState({form});
  }

  render() {
    return (
      <div>
        {this.renderErrors()}
        {this.renderForm()}
      </div>
    );
  }

  renderErrors() {
    if (!this.props.errors || this.props.errors.length === 0) {
      return ''
    }
    return (
      <div className="alert alert-danger">
        <ul>
          {this.props.errors.map(error => <li key={error}>{error}</li>)}
        </ul>
      </div>
    )
  }

  renderForm() {
    return (
      <form>
        {/*QUESTION TITLE*/}
        <div className="form-group">
          <label>Title: </label>
          <input className="form-control" type="text" id="title"
                 placeholder="What is your question? Be concise and specific."
                 value={this.state.form.title}
                 onChange={this.handleChange.bind(this)}
          />
        </div>

        {/*JURISDICTION*/}
        <div className="form-group">
          <label>Jurisdiction: </label>
          <select className="form-control" type="select" id="jurisdiction" value={this.state.form.jurisdiction}
                  onChange={this.handleChange.bind(this)}>
            {this.props.jurisdictions.map(jdx => <option value={jdx} key={jdx}>{jdx}</option>)}
          </select>
        </div>

        {/*QUESTION TAGS*/}
        <div className="form-group" ref="tags">
          <label>Tags: </label>
          <QuestionTags addTags={this.addTags.bind(this)} initialTags={this.props.question ? this.props.question.tags : []}/>
        </div>

        {/*QUESTION DETAIL (the main editor)*/}
        <div className="form-group">
          <label>Question Detail:</label>
          {this.renderEditor()}
        </div>

        {/*SUBMIT BUTTON*/}
        <div className="row">
          <div className="col-md-3 col-md-offset-10">
            <button className={`btn btn-primary ${this.props.submissionPending ? 'disabled' : ''}`}
                    onClick={this.handleSubmitClick.bind(this)}>
              Submit
            </button>
          </div>
        </div>
      </form>
    )
  }

  renderEditor() {

    return (
      <div className="form-group text-editor-form-group">
        <RichTextEditor onEditorChange={this.onEditorChange} initialEditorText={this.props.question ? this.props.question.body : ''}/>
      </div>
    );
  }
}


function mapStateToProps(state) {
  return {
    errors: state.questionForm.errors,
    submissionPending: state.questionForm.submissionPending,
    responseData: state.questionForm.response
  };
}

function mapDispatchToProps(dispatch) {
  return bindActionCreators({submitForm: submitForm}, dispatch);
}

export default connect(mapStateToProps, mapDispatchToProps)(QuestionFormContainer);