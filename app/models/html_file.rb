class HtmlFile
  include MongoMapper::Document

  key :filename, String
  key :file_hash, String
  key :description, String
  timestamps!

  self.ensure_index(:filename)

end
