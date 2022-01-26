require 'nokogiri'
require 'open-uri'
require 'byebug'

#
# This service is used to scrape a url and return the OG tags
#
class UrlScraper
  OG_TYPES = %w[url type title description locale
                image image:url image:secure_url image:type image:width image:height
                video video:url video:secure_url video:type video:width video:height].freeze

  def initialize(url)
    @url = url
  end

  def call
    domain = find_domain
    scrape(domain)

    {
      data: {
        domain: domain,
        tags: domain.tags
      }
    }
  end

  private

  def find_domain
    domain = Domain.find_or_create_by(url: @url)
    domain.update last_fetched: Time.new
    domain
  end

  def scrape(domain)
    doc = Nokogiri::HTML(URI.open(@url))
    OG_TYPES.each do |og_type|
      og_content = doc.xpath("/html/head/meta[@property='og:#{og_type}']/@content")[0]
      next unless og_content

      Tag.find_or_create_by(
        domain: domain,
        og_type: og_type,
        content: og_content.value
      )
    end
  end
end
