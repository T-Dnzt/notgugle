#This class parse the file and save the words in db
module SearchingTools
  module Indexer
	  class Parser

	  	def initialize(file, db, hashes)
	  		@file = file
	  		@filename = File.basename(file)
	  		@db = db
	  		@hashes = hashes

    		@word_weight = Hash.new(0)
    		@word_frequency = Hash.new(0)
    		@file_changed = false
	  	end

	  	#Create a new page in db and start to parse if the page has been modified
	  	def run
				if save_file
					doc = Nokogiri::HTML(open(@file,"r"))
					parse_page(doc)
					flush_page
			    save_words
			  end
			end

			def display_variables
				Rails.logger.debug "Number of word parsed : #{@word_weight.size}"
			end

private

		#Parse each html file in the specified directory
		def parse_page(doc)
		  @hashes.tags_weights.each do |tag, weight|
			  doc.xpath("//#{tag}").each do |node|
					parse_node(node.text, weight) 
				end
		  end
		  @hashes.special_tags_weights.each do |tag, desc_weight|
		  	doc.xpath("//#{tag}").each do |node|
		  	 parse_node(node.attr(desc_weight[0]), desc_weight[1])
		  	end
		  end
		end

		#Parse each tag to retrieve the word. Split everything which is not a letter or a space.
		def parse_node(node_text, weight)
		  node_text.gsub(/[^[:alpha:]]/, " ").downcase.split.each do |word|
		  	if !word.blank? && !@hashes.excluded_words_index.include?(word)
	          @word_weight[word] += weight
	          @word_frequency[word] += 1
        end
		  end
		end

		#Save each words contained in word_weight
		def save_words
		  @word_weight.each do |word, weight|
		   	@db.update_or_create_word(word, @filename, weight, @word_frequency[word])
		  end
		end

		def flush_page
			@db.flush_page(@word_weight, @filename, @file_changed)
		end

		#Check if the file has been modified or not and parse it depending on the result
		def save_file
			file_hash = Digest::MD5.hexdigest(File.read(@file))
			if file = @db.find_html_file(@filename)
				@file_changed = @db.check_or_update_if_file_changed(file, @filename, file_hash)
			else
				@db.create_html_file(@filename, file_hash)
			end
		end

	 end
  end
end