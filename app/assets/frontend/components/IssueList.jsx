import Issue from './Issue'

export default class IssueList extends React.Component {
  deleteIssue(tagId) {
    this.props.deleteIssue(tagId);
  }

  updateIssue(tagId, tagValue) {
    this.props.updateIssue(tagId, tagValue);
  }

  loadMore() { 
    this.props.loadMore();
  }

  render() {
//let issues = this.props.issues.map(issue => <Issue key={issue.id} {...issue} deleteIssue={this.deleteIssue.bind(this)} updateIssue={this.updateIssue.bind(this)} />);
    let self = this;
    let date = '';
    let issues = [];
    this.props.issues.map(function(issue){
      if (date != issue.happenedAt){
        date = issue.happenedAt;
        issues.push(<li className='date' key={date}>{date}</li>)
      }
      issues.push(<Issue key={issue.id} {...issue} deleteIssue={self.deleteIssue.bind(self)} updateIssue={self.updateIssue.bind(self)} />)
    })

    return (
      <div className='issue_list'> 
        <ul>
          {issues}
        </ul>

        <div style={{"textAlign": "center", "marginTop": "20px"}}>
          <input type="button" value="Load More" onClick={this.loadMore.bind(this)} />
        </div>
      </div>
    );
  }
}
