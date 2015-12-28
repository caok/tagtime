import IssueBox from './components/IssueBox'
import IssueList from './components/IssueList'

class Main extends React.Component {
  constructor(props) {
    super(props);
    this.state = { issueList: [] };
  }
  addIssue(issueToAdd) {
    let self = this;
    let newIssueList = self.state.issueList;
    $.ajax({ url: '/issues',
      type: 'POST',
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      data: {tag: issueToAdd},
      success: function(rsp) {
        if (rsp.type == 'success'){
          newIssueList.unshift(rsp.data);
          self.setState({ issueList: newIssueList });
        } else {
          console.log(rsp.message);
        }
      }
    });
  }
  componentDidMount() {
    $.ajax("/issues.json")
    .success(data => this.setState({ issueList: data }))
    .error(error => console.log(error));

    $.ajax({ url: '/projects/name_list',
      type: 'GET',
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      success: function(data) {
        $('input#issueArea').atwho({
          at: '@',
          data: data
        });
      }
    })
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
  let reactNode = document.getElementById('issues');
  if (reactNode) {
    ReactDOM.render(<Main />, reactNode);
  }
};

$(documentReady);
