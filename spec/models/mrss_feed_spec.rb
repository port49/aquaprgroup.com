require 'spec_helper'

describe MrssFeed do
  before(:each) do
    @xml = <<-XML
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<rss xmlns:atom="http://www.w3.org/2005/Atom" version="2.0" xmlns:media="http://search.yahoo.com/mrss/">
  <channel>
    <title>Image Gallery</title>
    <description>Interesting.</description>
    <link>http://spitzer.caltech.edu/resource_list/0-Image-Gallery</link>
    <atom:icon>http://spitzer.caltech.edu/images/spitzer_icon.png?1274224175</atom:icon>
    <item>
      <title>Blobs House Twin Stars</title>
      <description>New evidence from NASA's Spitzer Space Telescope is ...</description>
      <category>Observation</category>
      <link>http://spitzer.caltech.edu/images/3111-sig10-006-Blobs-House-Twin-Stars</link>
      <guid isPermaLink="false">3111-sig10-006-Blobs-House-Twin-Stars</guid>
      <pubDate>Thu, 20 May 2010 00:00:00 +0000</pubDate>
      <media:content type="image/jpeg" url="http://spitzer.caltech.edu/.../0005/7376/sig10-006_Sm.jpg" medium="image" fileSize="210851"/>
      <media:thumbnail url="http://spitzer.caltech.edu/uploaded_files/graphics/square_graphics/0005/7380/sig10-006_Tn.jpg"/>
    </item>
    <item>
      <title>Galactic Metropolis</title>
      <description>In this recent deep excavation, courtesy of NASA's Spitzer Space Telescope...</description>
      <category>Observation</category>
      <link>http://spitzer.caltech.edu/images/3106-sig10-005-Galactic-Metropolis</link>
      <guid isPermaLink="false">3106-sig10-005-Galactic-Metropolis</guid>
      <pubDate>Tue, 11 May 2010 00:00:00 +0000</pubDate>
      <media:content type="image/jpeg" url="http://spitzer.caltech.edu/.../0005/6488/sig10-005_Sm.jpg" medium="image" fileSize="182542"/>
      <media:thumbnail url="http://spitzer.caltech.edu/uploaded_files/graphics/square_graphics/0005/6492/sig10-005_Tn.jpg"/>
    </item>
    <item>
      <title>Pretty Picture</title>
      <description>In this recent deep excavation, courtesy of NASA's Spitzer Space Telescope...</description>
      <category>Artwork</category>
      <link>http://spitzer.caltech.edu/images/3106-sig10-005-Galactic-Metropolis</link>
      <guid isPermaLink="false">3106-sig10-005-Galactic-Metropolis</guid>
      <pubDate>Tue, 11 May 2010 00:00:00 +0000</pubDate>
      <media:content type="image/jpeg" url="http://spitzer.caltech.edu/.../0005/6488/sig10-005_Sm.jpg" medium="image" fileSize="182542"/>
      <media:thumbnail url="http://spitzer.caltech.edu/uploaded_files/graphics/square_graphics/0005/6492/sig10-005_Tn.jpg"/>
    </item>
  </channel>
</rss>
    XML

    class MrssFeed
      def self.all
        [
          self.new('http://example.com/test.xml')
        ]
      end
    end
    
    FakeWeb.register_uri(:get, "http://example.com/test.xml", :body => @xml)
  end
  
  it "should raise an error if no URL is given" do
    lambda{MrssFeed.new}.should raise_error
  end

  it "should load an external [fake] MRSS feed" do
    m = MrssFeed.new("http://example.com/test.xml")
    m.title.should == "Image Gallery"
    m.description.should == "Interesting."
    m.link.should == "http://spitzer.caltech.edu/resource_list/0-Image-Gallery"
    m.icon_path.should == "http://spitzer.caltech.edu/images/spitzer_icon.png?1274224175"
    m.should have(3).images
  end

  it "should load an external [fake] MRSS feed and have image information" do
    m = MrssFeed.new("http://example.com/test.xml")
    m.images[0,2].each do |image|
      ["Blobs House Twin Stars", "Galactic Metropolis"].should include image.title
      image.link.should match /^http:/
      image.category.should == "Observation"
      image.thumbnail.should match /^http:/
    end
  end

  it "should have some feeds hard-coded" do
    MrssFeed.all.should_not be_empty
    MrssFeed.all[0].should be_a(MrssFeed)
  end

  it "should filter feed items based on a category" do
    MrssFeed.by_category('Observation').should have(1).object
  end

  it "should find the feeds that we use" do
    [
      'http://www.herschel.caltech.edu/rss/images.xml',
      'http://spitzer.caltech.edu/resource_list/0?format=xml'
    ].each do |url|
      doc = Nokogiri::XML(open(url))
      doc.xpath('//channel').should have(1).channel
    end
  end

  it "should load a real remote feed" do
    MrssFeed.new('http://www.herschel.caltech.edu/rss/images.xml')
  end
end
