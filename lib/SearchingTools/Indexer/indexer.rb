module SearchingTools
  module Indexer
	  class Indexer
	  	class << self
	  		def run(options = {})
	  			#open yml config with tag's weight
	  			Rails.logger.info "Indexing..."
	  			parser = Parser.new(path_to_files, tag_weights, excluded_words)
	  			parser.run
	  		end

	  		def tag_weights
	  			tag_weights = {
	  				:p => 1,
	  				:h1 => 6,
	  				:h2 => 5,
	  				:h3 => 4
	  			}
	  		end

	  		def path_to_files
          		[Rails.root.join('html')]
	  		end

	  		def excluded_words
	  			%w{le la les je tu il elle nous vous elles ils}
	  		end

	  	end
	  end
  end
end