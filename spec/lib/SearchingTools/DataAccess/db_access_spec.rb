require File.expand_path(File.dirname(__FILE__) + '../../../../spec_helper')
require Rails.root.join('lib/SearchingTools/DataAccess/db_access')

describe SearchingTools::DataAccess::DbAccess do

  before :each do
    @db = SearchingTools::DataAccess::DbAccess.new("notgugle-test")
  end

  describe "database access" do
    it "should return a db object" do
      @db.should_not eq(nil)
    end

    it "should return the keywords collection" do
      keywords = @db.keywords
      keywords.name.should eq("keywords")
      keywords.should_not eq(nil)
    end

    it "should return the html files" do
      html_files = @db.html_files
      html_files.name.should eq("html_files")
      html_files.should_not eq(nil)
    end

    it "should create a keyword" do
      @db.keywords.remove()
      word = @db.update_or_create_word("Test", "test.html", "1", "1")
      @db.keywords.find().to_a.count.should eq(1)
    end

    it "should create a html file" do
      @db.html_files.remove()
      word = @db.create_html_file("test.html", "HASH")
      @db.html_files.find().to_a.count.should eq(1)
    end

    it "should return a word" do
      @db.keywords.remove()
      @db.update_or_create_word("Test", "test.html", "1", "1")
      @db.find_word("Test").should_not eq(nil)
    end

    it "should return a html file" do
      @db.html_files.remove()
      @db.create_html_file("test.html", "HASH")
      @db.find_html_file("test.html").should_not eq(nil)
    end

  end

end