ENV['SINATRA_ENV'] ||= "development"

require 'bundler/setup'
Bundler.require(:default, ENV['SINATRA_ENV'])

Time.zone = ENV["TZ"] || "America/New_York"

# ActiveRecord::Base.establish_connection(
#   :adapter => "sqlite3",
#   :database => "db/#{ENV['SINATRA_ENV']}.sqlite"
# )
ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || ENV['SINATRA_ENV'])

require './app/controllers/application_controller'
require_all 'app'
