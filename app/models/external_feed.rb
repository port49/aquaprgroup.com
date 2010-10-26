require 'open-uri'
require 'nokogiri'
require 'ostruct'

class ExternalFeed
  attr_accessor :title, :description, :link, :icon_path, :images

  def self.all
    [
      ExternalFeed.find_or_create_by_url('http://www.herschel.caltech.edu/rss/images.xml'),
      ExternalFeed.new('http://spitzer.caltech.edu/resource_list/0?format=xml')
    ]
  end

  def self.by_category(type_of_category)
    feeds = self.all
    feeds.each do |feed|
      feed.images = feed.images.select do |item|
        item.category.match(type_of_category)
      end
    end
  end

  def initialize(url)
    rss_feed = ExternalXmlResource.where(:url => url).first || ExternalXmlResource.new(:url => url, :refresh_rate => 4.hours)
    rss_feed.load

    doc = Nokogiri::XML(rss_feed.xml)
    channel = doc.xpath('//channel')[0]
    %w(title description link icon_path title).each do |accessor|
      self.send "#{accessor}=".to_sym, channel.xpath(accessor).try(:first).try(:content)
    end
    self.images = []
    doc.xpath('//item').each do |item|
      self.images << OpenStruct.new(
        :title => item.xpath('title').try(:first).try(:content),
        :link => item.xpath('link').try(:first).try(:content),
        :category => item.xpath('category').try(:first).try(:content),
        :thumbnail => (item.xpath('media:thumbnail').try(:first) || {})['url']
      )
    end
  end

end
