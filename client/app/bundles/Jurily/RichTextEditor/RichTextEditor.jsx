import React, {PropTypes} from 'react';
import ReactRTE, {EditorValue} from 'react-rte';


export default class RichTextEditor extends React.Component {

  static PropTypes = {
    editorSubmitAction: PropTypes.func.isRequired,
    submitting: PropTypes.bool.isRequired,
    baseClassName: PropTypes.string.isRequired,
    editorClassName: PropTypes.string.isRequired,
    toolbarClassName: PropTypes.string.isRequired,
    placeholder: PropTypes.string.isRequired
  };

  constructor(props, ctx) {
    super(props, ctx);
    this.state = {
      value: this.getInitialEditorValue(props),
      format: 'html',
      readOnly: false
    }
  }
  
  componentWillReceiveProps(nextProps) {
    if (nextProps.submitting) {
      this.props.editorSubmitAction(this.state.value.toString('html'));
    }
  }

  getInitialEditorValue(props) {
    if (props.initialEditorValue == undefined) return ReactRTE.createEmptyValue();
    return ReactRTE.createValueFromString(props.initialEditorValue, 'html');
  }

  handleChange(value:EditorValue) {
    this.setState({value})
  }

  render() {
    let cn = "rich-text-editor-test";
    let {value, readOnly} = this.state;
    return (
      <div>
        <ReactRTE
          value={value}
          onChange={this.handleChange.bind(this)}
          placeholder={this.props.placeholder}
          readOnly={readOnly}
          className={this.props.baseClassName}
          editorClassName={this.props.editorClassName}
          toolbarClassName={this.props.toolbarClassName}
        />
      </div>
    )
  }
}