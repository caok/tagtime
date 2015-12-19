import IssueBox from './components/IssueBox'
import IssueList from './components/IssueList'

class Main extends React.Component {
  constructor(props) {
    super(props);
    this.state = { issueList: [] };
  }
  addIssue(issueToAdd) {
    $.post("/apis/issues", {tag: issueToAdd})
    .success( savedIssue => {
      if (savedIssue.type == 'success'){
        let newIssueList = this.state.issueList;
        newIssueList.unshift(savedIssue.data);
        this.setState({ issueList: newIssueList });
      }else{
        console.log(savedIssue.message);
      }
    })
    .error(error => console.log(error));
  }
  componentDidMount() {
    $.ajax("/apis/issues")
    .success(data => this.setState({ issueList: data }))
    .error(error => console.log(error));
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
  let reactNode = document.getElementById('react');
  if (reactNode) {
    ReactDOM.render(<Main />, reactNode);
  }
};

$(documentReady);
