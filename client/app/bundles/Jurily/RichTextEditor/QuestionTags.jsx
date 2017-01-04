import React from 'react';
import TagsInput from 'react-tagsinput';

export default class QuestionTags extends React.Component {
  constructor(props) {
    super(props);
    this.state = {tags: []};
  }

  addTags(tags) {
    this.setState({tags})
  }

  render() {
    return <TagsInput onChange={::this.addTags} value={this.state.tags}/>
  }
}