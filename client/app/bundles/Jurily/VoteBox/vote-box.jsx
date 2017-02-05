import React, {PropTypes} from 'react';
import Superagent from 'superagent';

const UPVOTE = 1;
const DOWNVOTE = -1;
const NOVOTE = 0;
const QUESTION = "question";
const ANSWER = "answer";
const VOTE_TYPES = [UPVOTE, DOWNVOTE, NOVOTE];

export default class VoteBox extends React.Component {

  static PropTypes = {
    user: PropTypes.object,
    elementId: PropTypes.string.isRequired,
    elementType: PropTypes.string.isRequired,
    csrfToken: PropTypes.string.isRequired,
    hostUrl: PropTypes.string.isRequired
  };

  constructor(props, ctx) {
    super(props, ctx);
    this.state = {
      score: 0,
      userVote: NOVOTE
    }
  }

  componentDidMount() {
    this.getInitialVoteData();
  }

  getInitialVoteData() {
    Superagent
      .get(this.props.hostUrl)
      .query(this.getVoteboxIdInfo())
      .set('X-CSRF-Token', this.props.csrfToken)
      .set('Accept', 'application/json')
      .end((err, res) => {
        if (err || !res.ok) this.handleVoteGetError(err, res);
        else this.new_handleSubmitSuccess(res);
      });
  }

  handleVoteGetError(err, res) {
    //todo - error.
  }

  getVoteboxIdInfo() {
    return {
      vote: {
        user: this.props.user,
        elementId: this.props.elementId,
        elementType: this.props.elementType
      }
    };
  }

  checkLoginStatus() {
    if (!this.props.user) window.location.href = "/users/sign_in";
  }

  getVoteData(classList) {
    let voteType = "";
    if (classList.contains("vote-button-up")) voteType = UPVOTE;
    else if (classList.contains("vote-button-down")) voteType = DOWNVOTE;
    else {/*todo - handle error. */

    }
    return {
      user: this.props.user,
      elementId: this.props.elementId,
      elementType: this.props.elementType,
      voteType,
      currentUserVoted: this.state.currentUserVoted,
      currentUserVoteType: this.state.currentUserVoteType,
      score: this.state.score
    };
  }

  setUserVoteStatus(voteData) {

    if (voteData.currentUserVoted) {
      if (voteData.currentUserVoteType === voteData.voteType) {
        voteData.currentUserVoted = false;
        voteData.currentUserVoteType = null;
        voteData.score -= 1;
        return voteData;
      }
      else if (voteData.currentUserVoteType !== voteData.voteType) {
        voteData.score -= 2;
        return voteData;
      }
    }
    else if (!voteData.currentUserVoted) return voteData;
  }

  handleSubmitError(err, res) {
    //todo - handle submit error.

  }

  handleSubmitSuccess(res) {
    const resJson = JSON.parse(res.text);
    this.updateVoteData(resJson);
  }


  //todo - configure so that you're not updating props...
  updateVoteData(data) {
    this.setState({
      currentUserVoteType: data.voteType,
      currentUserVoted: data.currentUserVoted,
      score: data.score
    });
  }

  sendUserVoteData(voteData) {
    Superagent
      .post(this.props.hostUrl)
      .send(voteData)
      .set('X-CSRF-Token', this.props.csrfToken)
      .set('Accept', 'application/json')
      .end((err, res) => {
        if (err || !res.ok) this.handleSubmitError(err, res);
        else this.handleSubmitSuccess(res);
      });
  }

  handleVoteClick(e) {
    e.preventDefault();
    this.checkLoginStatus();
    let voteData = this.getVoteData(e.currentTarget.classList);
    voteData = this.setUserVoteStatus(voteData);
    this.sendUserVoteData(voteData);
    this.updateVoteData(voteData);
  }

  new_handleVoteClick(e) {
    e.preventDefault();
    this.checkLoginStatus();
    const voteData = this.new_getVoteData(e.currentTarget.classList);
    this.new_sendUserVoteData(voteData);
    this.new_updateVoteData(voteData)
  }

  new_getVoteData(classList) {
    const nextVote = this.determineNextVote(this.getVoteType(classList));
    return {
      user: this.props.user,
      elementId: this.props.elementId,
      elementType: this.props.elementType,
      userVote: nextVote,
      score: (this.state.score - this.state.userVote + nextVote)
    }
  }

  determineNextVote(nextVote) {
    //return no vote if vote is same.
    if (this.state.userVote == nextVote) return NOVOTE;
    return nextVote;
  }

  getVoteType(classList) {
    if (classList.contains("vote-button-up")) return UPVOTE;
    else if (classList.contains("vote-button-down")) return DOWNVOTE;
    else return NOVOTE;
  }

  new_sendUserVoteData(voteData) {
    Superagent
      .post(this.props.hostUrl)
      .send({vote: voteData})
      .set('X-CSRF-Token', this.props.csrfToken)
      .set('Accept', 'application/json')
      .end((err, res) => {
        if (err || !res.ok) this.handleSubmitError(err, res);
        else this.new_handleSubmitSuccess(res);
      });
  }

  new_handleSubmitSuccess(res) {
    this.new_updateVoteData(JSON.parse(res.text));
  }

  new_updateVoteData(data) {
    this.setState({
      score: data.score,
      userVote: data.userVote
    });
  }


  render() {
    return (
      <span>
        {this.renderVoteBox()}
      </span>
    )
  }


  renderVoteBox() {
    return (
      <div className="votebox">
        {this.renderVoteButton('up')}
        <div className="text-center">
          <p>{this.state.score}</p>
        </div>
        {this.renderVoteButton('down')}
      </div>
    )
  }

  renderVoteButton(direction) {
    let anchorClass = `vote-button-${direction} votebox-vote-button ${this.isActive(direction)}`;
    let iClass = `fa fa-chevron-circle-${direction} fa-3x votebox-vote-button`;
    return (
      <div className="vote-button-container">
        <p>
          <a className={anchorClass} onClick={this.new_handleVoteClick.bind(this)}>
            <i className={iClass} aria-hidden="true"/>
          </a>
        </p>
      </div>
    );
  }

  isActive(direction) {
    if (direction == 'up' && this.state.userVote == UPVOTE) return 'vote-active';
    if (direction == 'down' && this.state.userVote == DOWNVOTE) return 'vote-active';
  }
}