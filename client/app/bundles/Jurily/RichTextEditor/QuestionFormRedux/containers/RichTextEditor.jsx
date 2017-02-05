import React from 'react';
import ReactRTE, {EditorValue} from 'react-rte'

export default class RichTextEditor extends React.Component {

  constructor(props, ctx) {
    super(props, ctx);
    this.state = {
      value: this.getInitialEditorText(props),
      format: 'html',
      readOnly: false
    };
  }

  getInitialEditorText(props) {
    if (props.initialEditorText == undefined) return ReactRTE.createEmptyValue();
    return ReactRTE.createValueFromString(props.initialEditorText, 'html');
  }

  handleChange(value:EditorValue) {
    this.setState({value});
    if (this.props.onEditorChange) {
      this.props.onEditorChange(value.toString('html'));
    }
  }

  render() {
    let {value, readOnly} = this.state;
    return (
      <ReactRTE
        value={value}
        readOnly={readOnly}
        onChange={this.handleChange.bind(this)}
        placeholder="Provide further details regarding your question."
        className="question-editor-base"
        editorClassName="question-form-editor"
        toolbarClassName="question-form-toolbar"
      />
    )
  }
}
