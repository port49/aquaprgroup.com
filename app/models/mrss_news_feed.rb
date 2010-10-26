require 'ostruct'
class MrssNewsFeed
  attr_accessor :title, :description, :link, :icon_path, :images

  def self.all
    [
      self.new('http://www.herschel.caltech.edu/rss/news.xml')
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

  def self.by_project()
    feeds = self.all
    feeds.each do |feed|
      feed.images = feed.images.first
    end
  end

  def initialize(url)
    rss_feed = ExternalXmlResource.where(:url => url).first || ExternalXmlResource.new(:url => url, :refresh_rate => 1.minute)
    rss_feed.load

    doc = Nokogiri::XML(rss_feed.xml.to_s)
    channel = doc.xpath('//channel')[0]
    %w(title description link icon_path title).each do |accessor|
      self.send "#{accessor}=".to_sym, channel.xpath(accessor).try(:first).try(:content)
    end
    self.icon_path = channel.xpath('atom:icon').try(:first).try(:content)
    self.images = []
    doc.xpath('//item').each do |item|
      self.images << OpenStruct.new(
        :title => item.xpath('title').try(:first).try(:content),
        :link => item.xpath('link').try(:first).try(:content),
        :date => Date.parse(item.xpath('pubDate').try(:first).try(:content)),
        :description => item.xpath('description').try(:first).try(:content),
        :category => item.xpath('category').try(:first).try(:content),
        :thumbnail => (item.xpath('media:thumbnail').try(:first) || {})['url'],
        :image => (item.xpath('media:content').try(:first) || {})['url'],
        :guid => item.xpath('guid').try(:first).try(:content),
      )
    end
  end

end
