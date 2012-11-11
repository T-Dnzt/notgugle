module SearchingTools
  module Indexer
	  class Parser

	  	class << self
	  		def run(path, tags_weight)
				Dir.glob("#{path}/*.html") do |file|
					Rails.logger.info "Parsing file : #{file}"
					
					if page = save_page(file)
						f = File.open(file)
						doc = Nokogiri::HTML(f)
						
						tags_weight.each do |tag, weight|
							doc.xpath("//#{tag}").each do |node|
			  					Rails.logger.info node
			  					parse(node).each do |word|
			  						Rails.logger.info "New word #{word}!"
			  						save_word(page.id, word, tag.to_s, weight)
			  					end
			  				end
			  			end

						f.close
					end
				end
			end

			def parse(node)
				words = node.text.split(' ').each {|w| w.gsub!(/(\W|\d)/, "")}
			end

			def save_word(page_id, word, tag, weight)
				page = Page.find(page_id)
				page_keywords = page.keywords.collect { |k| k.word }
				if page_keywords.include?(word.downcase)
					keyword = Keyword.find_by_page_id_and_word(page.id, word.downcase)

					#Refactor with detect or find (from enumerable)
					tmp_hash = nil
					keyword.stats.each do |s|	
						if s["tag"] == tag
							tmp_hash = s
						end
					end

					if tmp_hash
						Rails.logger.info tmp_hash.inspect
						stats = keyword.stats
						stats.delete(tmp_hash)
						tmp_hash["frequency"] += 1
						stats << tmp_hash
						keyword.update_attributes(:stats => stats,
												  :weight => 0)
					else
						stats = keyword.stats 
						stats << {:tag => tag, :frequency => 1}
						keyword.update_attributes(:stats => stats,
												  :weight => 0)
					end
				else
					Keyword.create(:page => page,
								   :word => word.downcase,
								   :weight => 0,
								   :stats => [{:tag => tag,
								   			   :frequency => 1}])
				end 
			end

			def save_page(file_path)
				filename = File.basename(file_path)
				file_hash = Digest::MD5.hexdigest(File.read(file_path))
				if p = Page.find_by_filename(filename)
					if file_hash == p.file_hash
						p#should return nil in production
					else
						p.update_attribute(:file_hash, file_hash)
						p
					end
				else
					Page.create(:filename => filename,
								:file_hash => file_hash)
				end
			end
	  	end
	  end
  end
end