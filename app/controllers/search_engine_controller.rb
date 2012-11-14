class SearchEngineController < ApplicationController
	def index
    if params[:search]
		  @results = SearchingTools::Searcher::Searcher.run(params[:search]) 
    end
	end

	def indexer
		@indexing_state = (SearchingTools::Indexer::Indexer.run) ? "Ok" : "Non"
	end
end
