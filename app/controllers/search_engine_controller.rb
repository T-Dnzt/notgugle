class SearchEngineController < ApplicationController
	def index
		@results = SearchingTools::Searcher::Searcher.run(params[:search]) if params[:search]
	end

	def indexer
		@indexing_state = (SearchingTools::Indexer::Indexer.run) ? "Ok" : "Non"
	end
end
