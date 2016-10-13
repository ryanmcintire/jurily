class SearchController < ApplicationController

  def search

    puts 'testing...'
    handle_simple_search if simple_search

  end

  private

  def simple_search
    return true if params[:q][:simple]
    false
  end

  def handle_simple_search
    question_results = PgSearch.multisearch(params[:q][:simple]).where(:searchable_type => "Question")
    answer_results = PgSearch.multisearch(params[:q][:simple]).where(:searchable_type => "Answer")
    @results = []
    question_results.each do |r|
      @results << Question.find(r.searchable_id)
    end
    answer_results.each do |r|
      @results << Question.find((Answer.find(r.searchable_id)).question_id)
    end
  end

end
