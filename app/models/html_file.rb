class HtmlFile
  include MongoMapper::Document

  key :filename, String
  key :file_hash, String
  timestamps!

  self.ensure_index(:filename)

end
