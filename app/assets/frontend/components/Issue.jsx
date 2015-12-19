export default class Issue extends React.Component {
  render() {
    return (
      <li>
        <strong>{this.props.name}: </strong>
        <span>{this.props.body}</span>
      </li>
    );
  }
}
