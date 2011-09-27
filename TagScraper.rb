# Initial code written by Cyrus Stoller 2011

# the libraries I'm using to download the html I'm scraping from
require 'open-uri'
require 'nokogiri'

def main
  # the root url of the stanford course catalog
  root_url = "http://explorecourses.stanford.edu/CourseSearch/"

  # getting links to each of the departments course catalogs
  dept_links = getDeptLinks(root_url)
  
  # an overall array of tags that I'm writing out to a file
  tags = []
  
  # starting two files to dump the tags I download into
  f1 = File.open('tag_raw','w')
  f2 = File.open('tags_sorted','w')
  
  # going through each department
  dept_links.each do |link|
    # getting an array of tags from each department
    temp = openDeptLink(link,root_url)
    temp.each do |t|
      # checking that the tag has not already been added to my lists
      unless tags.include?(t)
        tags << t # adding this new tag to my overall array of tags
        f1.write(t) # writing the new tag to the unsorted output file
        f1.write("\n") # adding a new line after that tag
      end
    end
  end
  
  # sorting the tags by alphabetical order
  # downcase makes it so that all 'Tag' and 'tag' will be treated the same
  # otherwise I would get all of the uppercase words A-Z and then all of the
  # lowercase words a-z.
  tags.sort! { |a,b| a.downcase <=> b.downcase }
  
  # printing the tags to your terminal so you can see what's going on without
  # having to open the output files
  # puts tags
  
  # writing the tags now in alphabetical order to the sorted output file
  tags.each do |t|
    f2.write(t)
    f2.write("\n")
  end
  
  # closing the file streams you opened
  f1.close
  f2.close
end



# Getting links for each department

def getDeptLinks(root_url)
  # opening the link to the department page
  doc = Nokogiri::HTML(open("#{root_url}"))

  # creating an empty array of the links that is going to be returned
  dept_links = []

  #getting each dept link
  doc.css('a').each do |link|
    temp = link.attributes["href"].value
    dept_links << temp if temp[0] == 's'
  end

  #turning them into full urls since they're relative links on the page
  dept_links.map! do |d|
    "#{root_url}#{d}"
  end

  return dept_links
end

# Going through all of the courses listed for each department

def openDeptLink(link, base_url)
  # opening the department page
  doc = Nokogiri::HTML(open(link))

  # an array of all of the pages that need to be visited
  pages = [link]
  
  # getting all of the pagination links
  doc.css('#pagination > a').each do |link|
    temp = link.attributes["href"].value
    temp = "#{base_url}#{temp}"
    pages << temp unless pages.include?(temp)
  end

  # an empty array of all of the tags used by this department
  tags = []
  
  # go through each of the pages and get the tags used
  pages.each do |p|
    # show which page is being downloaded, so you know your program is doing something
    puts p 
    # get the words used on that page
    temp_tags = getTitleWords(p)
    # add only new tags to your array of tags for that department
    temp_tags.each do |t|
      tags << t unless tags.include?(t)
    end
  end
  return tags
end

# Getting all of the words taht are longer than 5 characters used in the titles

def getTitleWords(link)
  # open the page and get the HTML
  doc = Nokogiri::HTML(open(link))
  tags = []
  
  # get the course titles
  doc.css('.courseTitle').each do |title|
    # get the text of the course title
    text = title.children.first.text
    # get each individual word
    text_array = text.split(/\W/)
    text_array.each do |t|
      unless tags.include?(t)
        # only add words that are longer than 5 characters
        tags << t if t.length > 4
      end
    end
  end
  # puts tags
  return tags
end

# making it so calling 'ruby TagScraper.rb' will run the main functino

if __FILE__ == $PROGRAM_NAME
  main
end