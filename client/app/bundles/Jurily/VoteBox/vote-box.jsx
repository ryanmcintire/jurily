import React, {PropTypes} from 'react';
import Superagent from 'superagent';

const UPVOTE = "upvote";
const DOWNVOTE = "downvote";
const QUESTION = "question";
const ANSWER = "answer";
const VOTE_TYPES = [UPVOTE, DOWNVOTE];

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
      currentUserVoted: false,
      currentUserVoteType: ''
    }
  }

  checkLoginStatus() {
    if (!this.props.user) window.location.href = "/users/sign_in";
  }

  getVoteData(classList) {
    console.log('getting vote data');
    let voteType = "";
    if (classList.contains("vote-button-up")) voteType = UPVOTE;
    else if (classList.contains("vote-button-down")) voteType = DOWNVOTE;
    else {/*todo - handle error. */ console.log("ERROR!");}
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
    console.log("ERROR.");
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
    console.log('CLICK!');
    e.preventDefault();
    this.checkLoginStatus();
    let voteData = this.getVoteData(e.currentTarget.classList);
    voteData = this.setUserVoteStatus(voteData);
    this.sendUserVoteData(voteData);
    this.updateVoteData(voteData);
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
      <div className="vote-box-container">
        <div className="vote-button-container">
          <p>
            <a className="vote-button-up votebox-vote-button" onClick={this.handleVoteClick.bind(this)}>
              <i className="fa fa-chevron-circle-up fa-3x" aria-hidden="true"/>
            </a>
          </p>
        </div>
        <div className="votebox-score-container center-block">
          <p className="votebox-score">{this.state.score}</p>
        </div>
        <div className="vote-button-container">
          <p>
            <a className="vote-button-down votebox-vote-button" onClick={this.handleVoteClick.bind(this)}>
              <i className="fa fa-chevron-circle-down fa-3x" aria-hidden="true"/>
            </a>
          </p>
        </div>
      </div>
    )
  }
}