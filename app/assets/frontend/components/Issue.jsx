export default class Issue extends React.Component {
  render() {
    return (
      <li>
        <strong className='user' id={this.props.id}>{this.props.name}: </strong>
        <span className='body' onClick={this.editIssue.bind(this)}>{this.props.body}</span>
        <span className='time'>{this.props.happenedAt}</span>
        <span className='time'>{this.props.time}</span>
        <span className='operation' onClick={this.deleteIssue.bind(this, this.props.id)}> [delete]</span>
        <input type='text' id='issue_editor' onKeyDown={ this.updateIssue.bind(this, this.props.id) } onBlur={this.hiddenEditor} style={{display: 'none'}} />
      </li>
    );
  }

  deleteIssue(tagId) { 
    this.props.deleteIssue(tagId);
  }

  editIssue(event) {
    $("#issue_editor").css({"display":  "", "width": "500px"});
    $("#issue_editor").css("left", event.clientX);
    $("#issue_editor").css("top", event.clientY);
    $("#issue_editor").val("with " + this.props.content + " @" + this.props.project_name + " " + this.props.happenedAt + " #" + this.props.time);
  }

  hiddenEditor(event) {
    $("#issue_editor").css({"display":  "none"});
  }

  updateIssue(tagId, event) { 
    if(event.keyCode == 13) {
      $("#issue_editor").css({"display":  "none"}); 
      this.props.updateIssue(this.props.id, $("#issue_editor").val());
      $("#issue_editor").val('');
    }
  }
}
