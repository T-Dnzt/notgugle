module SearchingTools
  module Indexer
	  class Parser
	  	class << self
	  		def run(path, tags_weight)
				Dir.glob("#{path}/*.html") do |file|
					Rails.logger.info "Parsing file : #{file}"

					page = Nokogiri::HTML(open(file))

					Rails.logger.info page


				end
			end
	  	end
	  end
  end
end