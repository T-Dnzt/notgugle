module SearchEngineHelper

  def get_title(web_page)
    doc = Nokogiri::HTML(open(web_page,"r"))
    title = (doc.at_css("title"))
    (title.nil? || title.text.empty?)  ? "no title" : (doc.at_css("title")).text
  end

end
