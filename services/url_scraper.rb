require 'nokogiri'
require 'open-uri'
require './services/domain_serializer'

#
# This service is used to scrape a url and return the OG tags
#
class UrlScraper
  OG_TYPES = %w[url type title description locale
                image image:url image:secure_url image:type image:width image:height
                video video:url video:secure_url video:type video:width video:height].freeze
  URL_REGEX = 'https?:\/\/(www\.)[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)'.freeze

  def initialize(url)
    @url = url
  end

  def call
    error = verify_url
    return error if error

    res = find_domain
    return res if res[:error]

    scrape(res)

    DomainSerializer.new(res[:domain]).call
  end

  private

  def verify_url
    return if /#{URL_REGEX}/.match(@url)

    { error: 'Your URL needs to be of the following form: https://domain.tld' }
  end

  def find_domain
    doc = Nokogiri::HTML(URI.open(@url))

    domain = Domain.find_or_create_by(url: @url)
    domain.update last_fetched: Time.new

    { domain: domain, parsed: doc }
  rescue SocketError
    { error: 'This URL was not found.' }
  end

  def scrape(res)
    domain = res[:domain]
    parsed = res[:parsed]

    OG_TYPES.each do |og_type|
      og_content = parsed.xpath("/html/head/meta[@property='og:#{og_type}']/@content")[0]
      next unless og_content

      create_tag(domain, og_type, og_content)
    end
  end

  def create_tag(domain, og_type, og_content)
    Tag.find_or_create_by(
      domain: domain,
      og_type: og_type,
      content: og_content.value
    )
  end
end
