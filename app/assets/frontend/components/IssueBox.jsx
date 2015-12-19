export default class IssueBox extends React.Component {
  sendIssue(event) {
    event.preventDefault();
    this.props.sendIssue(this.refs.issueArea.value);
    this.refs.issueArea.value = '';
  }
  render() {
    return (
      <div>
        <form onSubmit={this.sendIssue.bind(this)}>
          <input type="text" ref='issueArea' />
          <button type='submit'>submit</button>
        </form>
      </div>
    );
  }
}
