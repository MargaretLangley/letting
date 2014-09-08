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
#
####
#
class SearchController < ApplicationController
  def index
    if match = LiteralSearch.search(type: model, query: params[:search]).go
      redirect_to match
    else
      results = FullTextSearch.search(type: model, query: params[:search]).go
      flash_no_results if results[:success] == false && params[:search].present?
      @records = results[:records].page(params[:page])
      render results[:render]
    end
  end

  private

  def model
    (Rails.application.routes.recognize_path(request.referrer)[:controller])
      .classify
  end

  def flash_no_results
    flash.now[:alert] = 'No Matches found. Search again.'
  end
end
