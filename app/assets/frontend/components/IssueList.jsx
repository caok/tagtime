import Issue from './Issue'

export default class IssueList extends React.Component {
  render() {
    let issues = this.props.issues.map(issue => <Issue key={issue.id} {...issue} />);
    return (
      <div>
        <ul>
          {issues}
        </ul>
      </div>
    );
  }
}
