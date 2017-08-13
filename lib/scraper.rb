require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
      html = File.read(index_url)
      student_index = Nokogiri::HTML(html)
      student_index.css("div.student-card").collect do |student_card|
        student_hash = {}
        student_hash[:name] = student_card.css("a div.card-text-container h4.student-name").text
        student_hash[:location] = student_card.css("a div.card-text-container p.student-location").text
        student_hash[:profile_url] = student_card.css("a").attribute("href").value
        student_hash
      end
  end

  def self.scrape_profile_page(profile_url)
    html = File.read(profile_url)
    student_profile = Nokogiri::HTML(html)
    student_hash = {}
    social_url_array = []
    student_profile.css("div.social-icon-container a").each do |element|
     social_url_array << element.attribute("href").value
      end
    social_url_array.each do |url|
      if url.include?("twitter.com")
        student_hash[:twitter] = url
      elsif url.include?("linkedin.com")
        student_hash[:linkedin] = url
      elsif url.include?("github.com")
        student_hash[:github] = url
      else
        student_hash[:blog] = url
      end
      end
      student_hash[:bio] = student_profile.css("div.description-holder p").text
      student_hash[:profile_quote] = student_profile.css("div.profile-quote").text
      student_hash

  end
end
