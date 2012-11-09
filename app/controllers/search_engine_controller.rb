class SearchEngineController < ApplicationController
	def index
	end

	def indexer
		SearchingTools::Indexer::Indexer.run
	end
end
