import React from 'React';
import TagsInput from 'react-tagsinput';

class TagTest extends React.Component {

  constructor(props) {
    super(props);
    this.state = {tags: []};
  }

  handleChange(tags) {
    this.setState({tags})
  }

  render() {
    return <TagsInput value={this.state.tags} onChange={::this.handleChange} />
  }

}

export default TagTest;