#encoding: utf-8
module SearchEngineHelper

  def get_title(web_page)
    doc = Nokogiri::HTML(open(web_page,"r"))
    title = (doc.at_css("title"))
    (title.nil? || title.text.empty?)  ? "no title" : (doc.at_css("title")).text
  end

  def pluralize_stats(count)
    found_pages = (count > 1) ? "pages trouvées" : "page trouvé"
    found_pages
  end

end
