module SearchingTools
  module Indexer
	  class Indexer
	  	class << self
	  		def run
	  			#open yml config with tag's weight
	  			Rails.logger.info "Indexing..."
          t1 = Time.now
          Dir.glob("#{path_to_files}/*.html") do |file|
            parser = Parser.new(file, tag_weights, tag_weights_special, excluded_words)
            parser.run
            parser.display_variables
          end
          t2 = Time.now
          Rails.logger.debug "Timer : #{t2 - t1}s"
	  		end

	  		def tag_weights
	  			{
  	  				"p" => 1,
  	  				"h1" => 3,
  	  				"h2" => 1.5,
  	  				"h3" => 1.4,
  		        "h4" => 1.3,
  		        "h5" => 1.2,
  		        "h6" => 1.1,
  		        "strong" => 2,
  		        "a" => 1.1,
  		        "link" => 4,
	  			}
	  		end

        def tag_weights_special
          {
              "meta[@name='keywords']" => ['content', 1],
              "meta[@name='description']" => ['content', 2],
              "img[@alt]" => ['alt', 1.2],
              "a[@title]" => ['title', 1.1]
          }
        end

	  		def path_to_files
          Rails.root.join('public/html')
	  		end

	  		def excluded_words
          %w{le la les je tu il elle nous vous elles ils leur leurs la mes ma mon mais ou est donc or ni car ni si un une des}
        end

	  	end
	  end
  end
end