I want to create an initial tag library that can be used to pre-populate the http://loopj.com/jquery-tokeninput/ plugin for Rails.

I've written a scraper to download all of the words that are longer than 5 characters used in course titles at Stanford as a start. I know that this data needs to be cleaned, but I figured that that would provide pretty broad coverage of topics. 

I would love help in creating a common data set that everyone can use.

SETUP:
(sudo) gem install nokogiri

Then 'ruby TagScraper' and you should be good to go. I wrote this with Ruby 1.9.2.