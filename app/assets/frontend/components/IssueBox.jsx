export default class IssueBox extends React.Component {
  sendIssue(event) {
    event.preventDefault();
    this.props.sendIssue(this.refs.issueArea.value);
    this.refs.issueArea.value = '';
  }
  render() {
    return (
      <div className='issue_box'>
        <form className='timer' onSubmit={this.sendIssue.bind(this)}>
          <input type="text" ref='issueArea' placeholder='What are you working on?' />
          <button type='submit'>submit</button>
        </form>
        <div className='clear'></div>
      </div>
    );
  }
}
