class SearchEngineController < ApplicationController
	def index
		#@results = SearchingTools::Searcher::Searcher.run(params[:search]) if params[:search]
    SearchingTools::Searcher::Searcher.run("hobby")
	end

	def indexer
		SearchingTools::Indexer::Indexer.run
	end
end
