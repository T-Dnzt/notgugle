module SearchingTools
  module Indexer
	  class Indexer
	  	class << self
	  		def run
	  			#open yml config with tag's weight
	  			Rails.logger.info "Indexing..."
	  			parser = Parser.new(path_to_files, tag_weights, excluded_words)
	  			parser.run
	  		end

	  		def tag_weights
	  			tag_weights = {
  	  				:p => 1,
  	  				:h1 => 3,
  	  				:h2 => 1.5,
  	  				:h3 => 1.4,
  		        :h4 => 1.3,
  		        :h5 => 1.2,
  		        :h6 => 1.1,
  		        :strong => 2,
  		        :img => 1.1, # to change : img.alt
  		        :a => 1.1, # to change : a.title
  		        :header => 2, # to change : header.keyword, header.description, header.title
  		        :link => 4
	  			}
	  		end

	  		def path_to_files
          		[Rails.root.join('html')]
	  		end

	  		def excluded_words
          %w{le la les je tu il elle nous vous elles ils leur leurs la mes ma mon mais ou est donc or ni car ni si un une des}
        end

	  	end
	  end
  end
end