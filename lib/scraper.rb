require "nokogiri"
require "open-uri"
require "pry"

class Scraper
  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    data = doc.css(".student-card").collect { |obj|
      Hash.new.tap { |hash|
        hash[:name] = obj.css(".student-name").text
        hash[:location] = obj.css(".student-location").text
        hash[:profile_url] = obj.css("a").attribute("href").content
      }
    }
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    Hash.new.tap { |hash|
      # hash[:name] = doc.css(".profile-name").text
      # hash[:location] = doc.css(".profile-location").text
      hash[:profile_quote] = doc.css(".profile-quote").text
      hash[:bio] = doc.css(".description-holder > p").text
      doc.css(".social-icon-container a").each {|obj|
        if obj.attribute("href").text.include?("twitter")
          hash[:twitter] = obj.attribute("href").text
        elsif obj.attribute("href").text.include?("linkedin")
          hash[:linkedin] = obj.attribute("href").text
        elsif obj.attribute("href").text.include?("github")
          hash[:github] = obj.attribute("href").text
        else
          hash[:blog] = obj.attribute("href").text
        end
      }
    }
  end
end
