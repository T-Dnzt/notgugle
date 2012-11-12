class Keyword
  include MongoMapper::Document

  belongs_to :page
  many :stats

  key :word, String
  key :weight, Integer
  timestamps!


  def get_current_stat(tag)
    self.stats.each {|stat| return stat if stat.tag == tag }
    nil
  end

end

class Stat
  include MongoMapper::EmbeddedDocument

  key :tag, String
  key :frequency, Integer 

end