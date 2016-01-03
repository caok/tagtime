export default class Issue extends React.Component {
  render() {
    return (
      <li>
        <span className='body' onClick={this.editIssue.bind(this)}>{this.props.body}</span>
        <span className='time'>{this.props.happenedAt}</span>
        <span className='time'>{this.props.time}</span>
        <span className='operation' onClick={this.deleteIssue.bind(this, this.props.id)}> [delete]</span>
        <input type='text' className="issue_editor" onKeyDown={this.updateIssue.bind(this, this.props.id)} onBlur={this.hiddenEditor} style={{display: 'none'}} />
      </li>
    );
  }

  deleteIssue(tagId) { 
    this.props.deleteIssue(tagId);
  }

  editIssue(event) { 
    $(".issue_editor").css({"display":  "none"});
    var editor = $(event.target).parent().children(".issue_editor")

    editor.css({"display":  "", "width": "800px"});
    editor.css("left", event.clientX);
    editor.css("top", event.clientY);
    editor.val("with " + this.props.content + " @" + this.props.project_name + " for" + " #" + this.props.number + " " + this.props.time);
  }

  hiddenEditor(event) {
    $(event.target).css({"display":  "none"});
  }

  updateIssue(tagId, event) { 
    if(event.keyCode == 13) {
      var editor = $(event.target);
      editor.css({"display":  "none"}); 
      this.props.updateIssue(this.props.id, editor.val());
      editor.val('');
    }
  }
}
