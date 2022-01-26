require 'sinatra'
require 'sinatra/activerecord'
require 'json'
require './models'
require './services/url_scraper'
require './services/domain_serializer'

set :database_file, './config/database.yml'
set :port, 8080

before do
  content_type :json
end

#
#  @params: optional: page[Integer] per_page[Integer]
#
get '/urls' do
  page = params[:page] || 1
  per_page = params[:per_page] || 5
  offset = page.to_i * per_page.to_i - per_page.to_i

  domains = Domain.includes(:tags).order(last_fetched: :desc).limit(per_page).offset(offset)
  serialized = DomainSerializer.new(domains, extra: { page: page, per_page: per_page }).call
  serialized.to_json
end

#
#  @params: required: url[String]
#
post '/url' do
  url = params[:url] || params['url']

  res = UrlScraper.new(url).call

  status 400 if res[:error]
  res.to_json
end
