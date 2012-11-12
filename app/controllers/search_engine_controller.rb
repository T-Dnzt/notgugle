class SearchEngineController < ApplicationController
	def index
		SearchingTools::Searcher::Searcher.run("ruby")
	end

	def indexer
		SearchingTools::Indexer::Indexer.run
	end
end
