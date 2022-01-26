require 'sinatra'
require 'sinatra/activerecord'
require 'json'
require './models'
require './services/url_scraper'

set :database_file, './config/database.yml'
set :port, 8080

before do
  content_type :json
end

get '/urls' do
  { data: Domain.all.order(:last_fetched, :dec) }.to_json
end

post '/url' do
  url = params[:url]
  res = UrlScraper.new(url).call

  res.to_json
end
