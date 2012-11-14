module SearchingTools
  module Searcher
    class SearchService

      def initialize(search, db, hashes)
        @search = search.split(' ').each {|w| w.gsub!(/[^[:alpha:]]/, "")}
        @db = db
        @hashes = hashes
      end

      def run
        get_results(get_matching_pages)
      end

private

      def get_results(pages)
        result_pages = Hash.new(0)
        desc_pages = Hash.new(0)

        result_pages = sum_weight(get_result_pages(pages, "filename"))

        result_pages.sort! {|a, b| b["weight"] <=> a["weight"] }

        result_pages.each do |f|
          f["words"] = f["words"].flatten(1).uniq
          unless get_description("#{f['filename']}").nil?
            desc_pages[f['filename']] = get_description("#{f['filename']}")
          end
        end
        return result_pages, desc_pages
      end

      def get_matching_pages
        pages = []
        @search.each do |word|
          unless @hashes.excluded_words_search.include?(word)
            matches = @db.keywords.find({'word' => /#{word}/i}).to_a
            matches.each do |match| 
              match["pages"].each do |p| 
                p["words"] = find_matches_per_page(p, matches)
                pages << p 
              end
            end
          end
        end
        pages
      end

      def find_matches_per_page(page, matches)
        page_words = []
        matches.each do |match|
          page_words << match["word"] if match["pages"].include?(page)
        end
        page_words
      end

      def get_result_pages(array, id)
        array.group_by {|row| row[id] }.collect do |k,v|
          keys = v.collect {|rec| rec.keys}.flatten.uniq
          group = {}
          keys.each do |key|
            vals = v.collect { |rec| rec[key] }.uniq.compact
            group[key] = vals.size > 1 ? vals : vals.first
          end
          group
        end
      end

      def sum_weight(array)
        array.each do |hash|
          hash["weight"] = hash["weight"].inject{|sum,x| sum + x } if hash["weight"].class == Array
        end
        array
      end

      def get_description(web_page)
        meta_content = nil
        doc = Nokogiri::HTML(open("#{Rails.root.join('public')}/html/#{web_page}","r"))
        doc.xpath("//meta[@name='description']").each { |node| meta_content = node.attr('content') }
        meta_content
      end

    end
  end
end