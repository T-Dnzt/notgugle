module SearchingTools
  module Indexer
	  class Indexer
	  	class << self
	  		def run
	  			#open yml config with tag's weight
	  			Rails.logger.info "Indexing..."
          t1 = Time.now
          Dir.glob("#{Rails.root.join('html')}/*.html") do |file|
            parser = Parser.new(file, tag_weights, excluded_words)
            parser.run
          end
          r2 = Time.now
          Rails.logger.debug r2 - t1
	  		end

	  		def tag_weights
	  			tag_weights = {
  	  				"p" => 1,
  	  				"h1" => 3,
  	  				"h2" => 1.5,
  	  				"h3" => 1.4,
  		        "h4" => 1.3,
  		        "h5" => 1.2,
  		        "h6" => 1.1,
  		        "strong" => 2,
  		        "img" => 1.1, # to change : img.alt
  		        "a" => 1.1, # to change : a.title
  		        "header" => 2, # to change : header.keyword, header.description, header.title
  		        "link" => 4
	  			}
	  		end

	  		def path_to_files
          		
	  		end

	  		def excluded_words
          %w{le la les je tu il elle nous vous elles ils leur leurs la mes ma mon mais ou est donc or ni car ni si un une des}
        end

	  	end
	  end
  end
end