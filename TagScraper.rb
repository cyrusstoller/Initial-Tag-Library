# Initial code written by Cyrus Stoller 2011

require 'open-uri'
require 'nokogiri'

def main
  # Perform a google search
  root_url = "http://explorecourses.stanford.edu/CourseSearch/"
  dept_links = getDeptLinks(root_url)
  tags = []
  
  f1 = File.open('tag_raw','w')
  f2 = File.open('tags_sorted','w')
  
  dept_links.each do |link|
    temp = openDeptLink(link,root_url)
    temp.each do |t|
      unless tags.include?(t)
        tags << t
        f1.write(t)
        f1.write("\n")
      end
    end
  end
  
  tags.sort! { |a,b| a.downcase <=> b.downcase }
  puts tags
  
  tags.each do |t|
    f2.write(t)
    f2.write("\n")
  end
  
  f1.close
  f2.close
end

def getDeptLinks(root_url)
  doc = Nokogiri::HTML(open("#{root_url}"))

  dept_links = []

  #getting each dept link
  doc.css('a').each do |link|
    temp = link.attributes["href"].value
    dept_links << temp if temp[0] == 's'
  end

  #turning them into full urls
  dept_links.map! do |d|
    "#{root_url}#{d}"
  end

  return dept_links
end

def openDeptLink(link, base_url)
  doc = Nokogiri::HTML(open(link))
  pages = [link]
  
  doc.css('#pagination > a').each do |link|
    temp = link.attributes["href"].value
    temp = "#{base_url}#{temp}"
    pages << temp unless pages.include?(temp)
  end

  tags = []
  pages.each do |p|
    puts p
    temp_tags = getTitleWords(p)
    temp_tags.each do |t|
      tags << t unless tags.include?(t)
    end
  end
  return tags
end

def getTitleWords(link)
  doc = Nokogiri::HTML(open(link))
  tags = []
  doc.css('.courseTitle').each do |title|
    text = title.children.first.text
    text_array = text.split(/\W/)
    text_array.each do |t|
      unless tags.include?(t)
        tags << t if t.length > 4
      end
    end
  end
  # puts tags
  return tags
end

if __FILE__ == $PROGRAM_NAME
  main
end