require 'ostruct'
class RssNewsFeed
  attr_accessor :title, :description, :link, :icon_path, :items

  def self.all
    [
      self.new('http://www.herschel.caltech.edu/rss/news.xml'),
      self.new('http://www.galex.caltech.edu/rss/galexnews.xml'),
      self.new('http://www.spitzer.caltech.edu/news_category?format=xml')
    ]
  end

  def self.full()
    feeds = self.all
    allitems = []
    feeds.each do |feed|
      allitems.concat(feed.items)
    end

    allitems.each do |item|
      news_url = item.link.downcase.split(".")
      news_title = item.title.downcase.gsub(/[']/, ' ').split(" ")
      projects = ["spitzer", "herschel", "galex"]

      news_project = news_url & projects
     
      # Attempt to find a refernce to the project name in the title
      # if news_project.empty?
      #   news_project = news_title & projects
      # end
     
      if news_project.empty?
        news_project = ["external"]
      end
      
      item.project = case news_project.first.to_s
         when "spitzer" then "Spitzer Space Telescope"
         when "herschel" then "Herschel Space Observatory"
         when "galex" then "Galaxy Evolution Explorer"
         else "External"
      end

    end
    allitems
  end

  def self.local()
    feeds = self.all
    allitems = []
    localitems = []
    feeds.each do |feed|
      allitems.concat(feed.items)
    end

    allitems.each do |item|
      news_url = item.link.downcase.split(".")
      news_title = item.title.downcase.gsub(/[']/, ' ').split(" ")
      projects = ["spitzer", "herschel", "galex"]

      news_project = news_url & projects
     
      # Attempt to find a refernce to the project name in the title
      # if news_project.empty?
      #   news_project = news_title & projects
      # end
     
      if news_project.empty?
        news_project = ["external"]
      end
      
      item.project = case news_project.first.to_s
         when "spitzer" then "Spitzer Space Telescope"
         when "herschel" then "Herschel Space Observatory"
         when "galex" then "Galaxy Evolution Explorer"
         else "External"
      end

    end

    allitems.each do |item|
      unless item.project == "External"
        localitems.push(item)
      end
    end

    localitems
  end

  def initialize(url)
    rss_feed = ExternalXmlResource.where(:url => url).first || ExternalXmlResource.new(:url => url, :refresh_rate => 1.minute)
    rss_feed.load

    doc = Nokogiri::XML(rss_feed.xml.to_s)
    channel = doc.xpath('//channel')[0]
    %w(title description link icon_path title).each do |accessor|
      self.send "#{accessor}=".to_sym, channel.xpath(accessor).try(:first).try(:content)
    end
    self.items = []
    doc.xpath('//item').each do |item|
      self.items << OpenStruct.new(
        :title => item.xpath('title').try(:first).try(:content),
        :link => item.xpath('link').try(:first).try(:content),
        :date => Date.parse(item.xpath('pubDate').try(:first).try(:content)),
        :description => item.xpath('description').try(:first).try(:content)
      )
    end
  end

end
