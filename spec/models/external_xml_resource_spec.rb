require 'spec_helper'

describe ExternalXmlResource do
  it "should initially be empty" do
    d = ExternalXmlResource.new
    d.xml.should be_nil
  end

  it "should load the data from a remote resource if it is a new feed" do
    xml = <<-XML
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <country>
        <name>USA</name>
      </country>
    XML
    FakeWeb.register_uri(:get, "http://example.com/test.xml", :body => xml)
    d = ExternalXmlResource.new(:url => "http://example.com/test.xml")
    d.load
    d.xml.should == xml
  end

  it "should return the same data as long as the refresh rate hasn't expired" do
    xml = []
    xml << <<-XML
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <country>
        <name>USA</name>
      </country>
    XML
    xml << <<-XML
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <country>
        <name>Canada</name>
      </country>
    XML
    FakeWeb.register_uri(:get, "http://example.com/test.xml", :body => xml[0])
    d = ExternalXmlResource.new(:url => "http://example.com/test.xml", :refresh_rate => 4.hours)
    d.load
    d.xml.should == xml[0]
    FakeWeb.register_uri(:get, "http://example.com/test.xml", :body => xml[1])
    d = ExternalXmlResource.where(:url => "http://example.com/test.xml").first
    d.load
    d.xml.should == xml[0]
  end

  it "should return the new data when the refresh rate has expired" do
    xml = []
    xml << <<-XML
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <country>
        <name>USA</name>
      </country>
    XML
    xml << <<-XML
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <country>
        <name>Canada</name>
      </country>
    XML
    FakeWeb.register_uri(:get, "http://example.com/test.xml", :body => xml[0])
    d = ExternalXmlResource.new(:url => "http://example.com/test.xml", :refresh_rate => -100)
    d.load
    d.xml.should == xml[0]
    FakeWeb.register_uri(:get, "http://example.com/test.xml", :body => xml[1])
    d = ExternalXmlResource.where(:url => "http://example.com/test.xml").first
    d.load
    d.xml.should == xml[1]
  end
end
