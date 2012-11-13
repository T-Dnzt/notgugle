class Keyword
  include MongoMapper::Document

  many :pages

  key :word, String

  self.ensure_index(:word)
end

class Page
  include MongoMapper::EmbeddedDocument

  key :filename, String
  key :weight, Float
  key :frequency, Integer

end
