module SearchingTools
  module Indexer
	  class Parser

	  	def initialize(file, tags_weight, excluded_words)
	  		@file = file
	  		@tags_weight = tags_weight
	  		@excluded_words = excluded_words
    		@word_weight = Hash.new(0)
    		@word_frequency = Hash.new(0)
    		@file_changed = false
    		@db = Mongo::Connection.new.db('notgugle-development')
	  	end

	  	#Create a new page in db and start to parse if the page has been modified
	  	def run
				if save_page
					doc = Nokogiri::HTML(open(@file,"r"))
					parse_page(doc)
			  end
			  clean_weight
			  save_words
			end

private

		#Parse each html file in the specified directory
		def parse_page(doc)
		  @tags_weight.each do |tag, weight|
			  doc.xpath("//#{tag}").each do |node|
		  	  parse_node(node, weight)
		    end
		  end
		end

		#Parse each tag to retrieve the word. Split everything which is not a letter or a space.
		def parse_node(node, weight)
		  node.text.gsub(/[^[:alpha:]]/, " ").downcase.split.each do |word|		  	
		  	if word.length > 1 && !@excluded_words.include?(word)
          @word_weight[word] += weight
          @word_frequency[word] += 1
        end
		  end
		end

		def save_words
			 word_collection = @db.collection("keywords")
			 filename = File.basename(@file)
		   @word_weight.each do |word, weight|
		      id = word_collection.update({ 'word' => word }, {'$addToSet' => { 'pages' => { 'filename' => filename, 'weight' => weight, 'frequency' => @word_frequency[word] }}}, :upsert => true)
		   	end
		end

		def clean_weight
			 word_collection = @db.collection("keywords")
			 @word_weight.each do |word, weight|
			  if @file_changed && e_word = word_collection.find_one({ 'word' => word })
			  	e_word["pages"] = e_word["pages"].reject { |h| h["filename"] == File.basename(@file) } 
				  word_collection.save(e_word)
				 end
			 end
		end

		def save_page
			filename = File.basename(@file)
			files_collection = @db.collection("html_files")
    	file_hash = Digest::MD5.hexdigest(File.read(@file))

	    if file = files_collection.find_one({'filename' => filename})
	    	if file_hash == file["file_hash"]
	    		nil
	    	else
	      	files_collection.update({'filename' => filename }, { 'file_hash' => file_hash})
	    		@file_changed = true
	      	true
	    	end
	    else
	    	files_collection.insert({ 'filename' => filename, 'file_hash' => file_hash })
	    	true
	    end
		end

	 end
  end
end