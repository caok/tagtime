import Issue from './Issue'

export default class IssueList extends React.Component {
  deleteIssue(tagId) {
    this.props.deleteIssue(tagId);
  }

  updateIssue(tagId, tagValue) {
    this.props.updateIssue(tagId, tagValue);
  }

  render() {
    let issues = this.props.issues.map(issue => <Issue key={issue.id} {...issue} deleteIssue={this.deleteIssue.bind(this)} updateIssue={this.updateIssue.bind(this)} />);
    return (
      <div className='issue_list'>
        <ul>
          {issues}
        </ul>
      </div>
    );
  }
}
