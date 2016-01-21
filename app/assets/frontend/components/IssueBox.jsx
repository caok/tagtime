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
          <input type="text" id='issueArea' ref='issueArea' placeholder='What are you working on?' autoComplete="off" />
          <button type='submit'>submit</button>
        </form>
        <div className='clear'></div>
        <p id='hint'>hint: @project #number content 1h20m 12/30</p>
      </div>
    );
  }
}
