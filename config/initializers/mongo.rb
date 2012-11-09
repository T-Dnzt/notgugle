
mongo_url = ENV['MONGOLAB_URI'] || "mongodb://localhost:27017/notgugle-#{Rails.env}"
uri = URI.parse(mongo_url)
database = uri.path.gsub('/', '')

MongoMapper.connection = Mongo::Connection.new(uri.host, uri.port, {})
MongoMapper.database = database
if uri.user.present? && uri.password.present?
  MongoMapper.database.authenticate(uri.user, uri.password)
end

if defined?(PhusionPassenger)
	PhusionPassenger.on_event(:starting_worker_process) do |forked|
		MongoMaper.connection.connect if forked
	end
end