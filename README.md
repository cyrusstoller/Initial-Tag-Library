I've written a scraper to download all of the words that are longer than 5 characters used in course titles at Stanford. This should give you an idea of how to write a basic web scraper.

##SETUP:
`(sudo) gem install nokogiri`

Then 'ruby TagScraper' and you should be good to go. I wrote this with Ruby 1.9.2.

I initially wrote this to create an initial tag library that can be used to pre-populate the http://loopj.com/jquery-tokeninput/ plugin for Rails.

This isn't as necessary anymore, because custom tokens have been added as a feature in this fork of the jquery plugin https://github.com/cyrusstoller/jquery-tokeninput.

Here's a more detailed write up: http://www.cyrusstoller.com/2011/03/22/how-to-write-a-webscraper/
