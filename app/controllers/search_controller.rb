####
#
# SearchController
#
# Handles main search requests for the application.
#
# Search requests entered into the top 'search' in the
# header are piped through this controller.
# Literal controller is responsible for exact matches.
# FullTextSearch is responsible for the fuzzy searching.
#
# rubocop: disable Lint/AssignmentInCondition
# REFACTOR index TODO:
# rubocop: disable  Metrics/MethodLength
#
####
#
class SearchController < ApplicationController
  def index
    session[:search_model] = referer_model unless referer_model == 'Search'
    match = LiteralSearch.search(type:  session[:search_model],
                                 query: params[:search_terms]).go
    if match[:record_id] || match[:process_empty] == 'true'
      redirect_to controller: match[:controller],
                  action: match[:action],
                  id: match[:record_id],
                  search_terms: params[:search_terms]
    else
      results = full_text_search search_model: session[:search_model],
                                 query: params[:search_terms]
      @records = results[:records].page(params[:page])
      render results[:render]
    end
  end

  private

  def full_text_search(search_model:, query:)
    results = FullTextSearch.search(type:  search_model, query: query).go
    flash_no_results if results[:success] == false && query.present?
    results
  end

  def referer_model
    (Rails.application.routes.recognize_path(request.referrer)[:controller])
      .classify
  end

  def flash_no_results
    flash.now[:alert] = 'No Matches found. Search again.'
  end
end
