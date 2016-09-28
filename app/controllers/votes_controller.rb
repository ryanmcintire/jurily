class VotesController < ApplicationController
  #before_action :ensure_json_request
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

  private
  def process_vote
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
      response_data = {
          :currentUserVoted => current_user_voted?(vote),
          :currentUserVoteType => current_user_vote_type(vote),
          :score => get_score(element.votes)
      }
      return response_data
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
