import IssueBox from './components/IssueBox'
import IssueList from './components/IssueList'

class Main extends React.Component {
  constructor(props) {
    super(props);
    this.state = { issueList: [] };
  }
  addIssue(issueToAdd) {
    let newIssueList = this.state.issueList;
    newIssueList.unshift({ id: Date.now(), name: 'Guest', body: issueToAdd });

    this.setState({ issueList: newIssueList });
  }
  render() {
    return (
      <div className="container">
        <IssueBox sendIssue={this.addIssue.bind(this)} />
        <IssueList issues={this.state.issueList} />
      </div>
    );
  }
}

let documentReady = () => {
  ReactDOM.render(
    <Main />,
    document.getElementById('react')
  );
};

$(documentReady);
