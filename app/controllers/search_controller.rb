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
# rubocop: disable Style/AccessorMethodName
#
####
#
class SearchController < ApplicationController
  def index
    if literal_search.go.found?
      if literal_search.go.single_record?
        # repack search params otherwise the search is 'forgotten'
        redirect_to literal_search.go.to_params.merge(repack_search_params)
      else
        @records = literal_search.go.records
        render literal_search.go.to_render
      end
    else
      @records = full_text_search[:records].page(params[:page])
      render full_text_search[:render]
    end
  end

  private

  def literal_search
    @literal_search ||= LiteralSearch.search(referrer: referrer,
                                             query: params[:search_terms])
  end

  def repack_search_params
    { search_terms: params[:search_terms] }
  end

  def full_text_search
    @full_text_search ||= get_full_text_search
  end

  def get_full_text_search
    results = FullTextSearch.search(referrer: referrer,
                                    query: params[:search_terms]).go
    flash.now[:problem] = 'No Matches found. Search again.' \
      if params[:search_terms].present? && results[:records].count.zero?
    results
  end
end
