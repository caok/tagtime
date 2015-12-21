export default class Issue extends React.Component {
  render() {
    return (
      <li>
        <strong className='user'>{this.props.name}: </strong>
        <span className='body'>{this.props.body}</span>
        <span className='time'>{this.props.time}</span>
      </li>
    );
  }
}
