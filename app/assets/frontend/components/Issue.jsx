export default class Issue extends React.Component {
  render() {
    return (
      <li>
        <strong className='user' id={this.props.id}>{this.props.name}: </strong>
        <span className='body'>{this.props.body}</span>
        <span className='time'>{this.props.time}</span>
        <span className='operation' onClick={this.deleteIssue.bind(this, this.props.id)}>delete</span>
      </li>
    );
  }

  deleteIssue(tagId) { 
    this.props.deleteIssue(tagId);
  }
}
