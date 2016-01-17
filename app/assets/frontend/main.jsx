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

  deleteIssue(tagId) { 
    let self = this;
    $.ajax({ 
      type: 'DELETE',
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      url: '/issues/' + tagId
    }).success((res) => {
      let issueList = self.state.issueList;
      if (res.type == 'success'){
        //self.setState({ issueList: res.list });
        for (var i=0; i<issueList.length; i++){
          if (issueList[i].id == tagId) {
            issueList.splice(i,1);
            break;
          }
        };
        self.setState({ issueList: issueList });
      } else {
        console.log(res.message);
      } 
    })
  }

  updateIssue(tagId, tagValue) {
    let self = this;
    $.ajax({ 
      type: 'PATCH',
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      url: '/issues/' + tagId,
      data: {tag: tagValue}
    }).success((res) => {
      let issueList = self.state.issueList;
      if (res.type == 'success'){
        for (var i=0; i<issueList.length; i++){
          if (issueList[i].id == tagId) {
            issueList[i] = res.data;
            break;
          }
        };
        self.setState({ issueList: issueList });
      } else {
        console.log(res.message);
      } 
    })
  }

  loadMore() {
    let self = this;

    $.ajax({ 
      type: 'GET',
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      url: '/issues/load_more'
    }).success((res) => {
      if (res.type == 'success'){
        self.setState({ issueList: res.list });
      } else {
        console.log(res.message);
      } 
    })
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
        <IssueList issues={this.state.issueList} deleteIssue={this.deleteIssue.bind(this)} updateIssue={this.updateIssue.bind(this)} loadMore={this.loadMore.bind(this)}/>
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
