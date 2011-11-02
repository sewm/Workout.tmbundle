#!/usr/bin/ruby

require 'rexml/document'
include REXML

DIRECTORY = "/Users/sam/Documents/Fitness/Workouts"

total_distance, total_2009, total_2010, total_2011 = 0.00, 0.00, 0.00, 0.00
total_rides, total_rides_2009, total_rides_2010, total_rides_2011 = 0, 0, 0, 0

Dir.glob(DIRECTORY + "/*.xml") do |file|
  year = file.match(/20\d\d/).to_s

  xml = Document.new(File.open(file))
  
  distance =  XPath.first(xml, "//distance")
  if distance
    d = distance.text.to_f
    
    total_distance += d
    total_rides += 1
    
    case year
    when "2009"
      total_2009 += d
      total_rides_2009 += 1
    when "2010"
      total_2010 += d
      total_rides_2010 += 1
    when "2011"
      total_2011 += d
      total_rides_2011 += 1
    else
      puts "<p>Add case for #{year}</p>"
    end
      
  end
end

puts "<p>Total Distance: #{total_distance} km in #{total_rides} rides.</p>"
puts "<p>Total Distance for 2009: #{total_2009} km in #{total_rides_2009} rides.</p>"
puts "<p>Total Distance for 2010: #{total_2010} km in #{total_rides_2010} rides.</p>"
puts "<p>Total Distance for 2011: #{total_2011} km in #{total_rides_2011} rides.</p>"
