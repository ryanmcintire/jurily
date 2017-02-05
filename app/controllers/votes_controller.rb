class VotesController < ApplicationController
  #before_action :ensure_json_request
  before_action :authenticate_user!, only: :new_new_vote
  respond_to :json

  def vote
    #todo - get vote data
    #todo - how to accept properly-formatted json
    #todo - sanitize json
    response_data = process_vote
    respond_to do |format|
      format.json { render :json => response_data.to_json }
    end
  end

  def get_vote
    vote_data = vote_params
    element = new_get_element vote_data
    current_user_vote = get_current_user_vote element
    response_data = {
        :score => element.score,
        :userVote => current_user_vote.nil? ? 0 : current_user_vote.value
    }
    respond_to do |format|
      format.json {render :json => response_data.to_json}
    end

  end

  private
  def process_vote
    vote_data = vote_params
    element = new_get_element vote_data
    current_user_vote = get_current_user_vote element
    if current_user_vote
      vote = process_existing_vote(vote_data, current_user_vote)
    else
      vote = new_new_vote(vote_data)
    end
    element.votes << vote if vote
    if element.save
      {
          :score => element.score,
          :userVote => vote.nil? ? 0 : vote.value
      }
    end
  end

  def process_existing_vote(vote_data, current_user_vote)
    new_vote = nil
    new_vote = new_new_vote(vote_data) if vote_data['userVote'] != current_user_vote.value
    current_user_vote.destroy
    new_vote
  end

  def new_new_vote(vote_data)
    Vote.new(user_id: current_user.id, value: vote_data['userVote'])
  end

  def get_current_user_vote(element)
    return nil if current_user.nil?
    current_user_vote = element.votes.where(user_id: current_user.id)
    #todo - better error tracking.
    current_user_vote[0]
  end

  def vote_params
    params.require(:vote).permit(:elementId, :elementType, :user, :userVote)
  end

  def old_process_vote
    response_data = {}
    element = get_element_from_params
    #todo - user logged in?
    current_user_vote = element.votes.where(user_id: @current_user_id)
    if current_user_vote.count == 0
      vote = new_vote
    elsif current_user_vote.count == 1
      current_user_vote[0].destroy
      vote = new_vote if (current_user_vote[0].value == 1 and params[:voteType] == "downvote") or
          (current_user_vote[0].value == -1 and params[:voteType] == "upvote")
    else
      #todo - catch error.
    end
    element.votes << vote if vote != nil

    if element.save
      {
          :currentUserVoted => current_user_voted?(vote),
          :currentUserVoteType => current_user_vote_type(vote),
          :score => get_score(element.votes)
      }
    else
      #todo - error...
    end
  end

  def get_score(votes)
    score = 0
    votes.each { |v| score += v.value }
    score
  end

  def current_user_vote_type(vote)
    return nil if vote == nil
    return :upvote if vote.value == 1
    return :downvote if vote.value == -1
  end

  def current_user_voted?(vote)
    vote == nil ? false : true
  end

  def new_vote
    vote = Vote.new(user_id: @current_user_id)

    if params[:voteType] == "upvote"
      vote.value = 1
    elsif params[:voteType] == "downvote"
      vote.value = -1
    else
      #todo - error
    end
    vote
  end

  def new_get_element(vote_data)
    return Question.find(vote_data['elementId']) if vote_data['elementType'] == 'question'
    return Answer.find(vote_data['elementId']) if vote_data['elementType'] == 'answer'
    #todo - handle error
  end

  def get_element_from_params
    #todo - testing
    element_type = params[:elementType]
    if element_type == "question"
      return Question.find(params[:elementId])
    elsif element_type == "answer"
      return Answer.find(params[:elementId])
    else
      #todo - error
      #todo - send response!
    end
  end

  def ensure_json_request
    return if request.format == :json
    render :nothing => true, :status => 406
  end

end
