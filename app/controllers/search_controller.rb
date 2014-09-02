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
    if exact_match = LiteralSearch.go(params[:search])
      redirect_to exact_match
    else
      results = FullTextSearch.search(type: referer_controller,
                                      query: params[:search])
                              .go
      flash_no_results if results[:success] == false && params[:search].present?
      @records = results[:records].page(params[:page])
      render results[:render]
    end
  end

  private

  def referer_controller
    Rails.application.routes.recognize_path(request.referrer)[:controller]
  end

  def flash_no_results
    flash.now[:alert] = 'No Matches found. Search again.'
  end
end
