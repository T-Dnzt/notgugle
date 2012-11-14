module SearchEngineHelper

  def get_description(web_page)
    meta_content = nil
    doc = Nokogiri::HTML(open("#{Rails.root.join('public')}/html/#{web_page}","r"))
    doc.xpath("//meta[@name='description']").each { |node| meta_content = node.attr('content') }
    meta_content
  end

  def get_title(web_page)
    doc = Nokogiri::HTML(open(web_page,"r"))
    title = (doc.at_css("title"))
    (title.nil? || title.text.empty?)  ? "no title" : (doc.at_css("title")).text
  end

end
