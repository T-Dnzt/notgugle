module SearchingTools
  module Indexer
	  class Parser

	  	def initialize(file, tags_weight, excluded_words)
	  		@file = file
	  		@page = nil
	  		@tags_weight = tags_weight
	  		@excluded_words = excluded_words
	  		connection = Mongo::Connection.new.db('notgugle-development')
    		@word_collection = connection.collection("keywords")
    		@page_collection = connection.collection("pages")
	  	end

	  	#Create a new page in db and start to parse if the page has been modified
	  	def run
				if page = save_page
					Rails.logger.info "Parsing file #{@file}"
					@page = page
					doc = Nokogiri::HTML(open(@file))
					parse_page(doc)
			  end
			end

private

		#Parse each html file in the specified directory
		def parse_page(doc)
		  @tags_weight.each do |tag, weight|
			  doc.xpath("//#{tag}").each do |node|
		  	  parse_node(node, tag)
		    end
		  end
		end

		#Parse each tag to retrieve the word. Split everything which is not a letter or a space.
		def parse_node(node, tag)
		  node.text.gsub(/[^[:alpha:]]/, " ").downcase.split.each do |word|
		  	if !word.blank? && !@excluded_words.include?(word)
		  		save_word(word, tag)
        end
		  end
		end

		def save_word(word, tag)
			if keyword = @word_collection.find(word: word, page_id: @page.id).to_a.first
				weight = keyword['weight'] + @tags_weight[tag].to_f
				@word_collection.update({ word: word, page_id: @page.id }, {'weight' => weight })
			else
				@word_collection.insert({'page_id' => @page.id, 'word' => word, 'weight' => @tags_weight[tag].to_f})
			end	
		end

		#Save or update a page in db. Check the md5 to see if anything changed
		def save_page
			filename = File.basename(@file)
    	file_hash = Digest::MD5.hexdigest(File.read(@file))
	    if page = @page_collection.find(filename: filename).to_a.first
	    	Rails.logger.info "File existing"
	      if file_hash == page["file_hash"]
	      	@page = nil
	      	nil
	      else
	      	page.update_attribute(:file_hash, file_hash)
	      	page
	      end
	    else
	      Rails.logger.info "New file"

	      Page.create(:filename => filename,
	                  :file_hash => file_hash)
	    end  
		end

	 end
  end
end