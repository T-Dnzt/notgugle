require File.expand_path(File.dirname(__FILE__) + '../../../../spec_helper')
Dir[Rails.root + 'lib/**/*.rb'].each {|lib| require lib }


describe SearchingTools::Indexer::Parser do

  before :all do
    hashes = SearchingTools::DataAccess::HashAccess.new
    rspec_test = Rails.root.join('public/html/rspec_test.html')
    source_file = Rails.root.join('public/html/test.html')
    system "cp #{source_file} #{rspec_test}"

    @db = SearchingTools::DataAccess::DbAccess.new("notgugle-test")
    @parser = SearchingTools::Indexer::Parser.new(rspec_test, @db, hashes )
  end

  before :each do
    @db.keywords.remove
    @db.html_files.remove
  end


  describe "Indexing" do
    it "should add test.html words in db" do
      @parser.run
      @db.keywords.count.should > 0
    end
  end

end