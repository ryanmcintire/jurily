class SearchController < ApplicationController

  def search
    handle_simple_search if simple_search
  end

  def advanced_search

  end

  private

  def simple_search
    return true if params[:q][:simple]
    false
  end

  def handle_simple_search
    #todo - resolve issue finding deleted items
    question_results = PgSearch.multisearch(params[:q][:simple]).where(:searchable_type => "Question")
    answer_results = PgSearch.multisearch(params[:q][:simple]).where(:searchable_type => "Answer")
    @results = []
    question_results.each do |r|
      question = Question.find_by_id(r.searchable_id)
      next if question.nil?
      @results << question
    end
    answer_results.each do |r|
      answer = Answer.find_by_id(r.searchable_id)
      next if answer.nil?
      question = Question.find_by_id(answer.question_id)
      next if question.nil?
      @results << question
    end
  end

end
