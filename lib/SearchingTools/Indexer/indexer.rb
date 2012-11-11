module SearchingTools
  module Indexer
	  class Indexer
	  	class << self
	  		def run(options = {})
	  			#open yml config with tag's weight
	  			Rails.logger.info "Indexing..."
	  			Parser.run(path_to_files, tag_weights)
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
	  			"/Volumes/Data/Thibault/Pro/Ingesup/M2/SEO/notgugle/html"
	  		end
	  	end
	  end
  end
end