#!/usr/bin/ruby

require 'rexml/document'
include REXML

# Set this to the directory containing the workout data.
DIRECTORY = "/Users/sam/Documents/Fitness/Workouts"

# Variables for distance, number of bike rides and hours ridden.
total_distance, total_2009, total_2010, total_2011 = 0.00, 0.00, 0.00, 0.00
total_rides, total_rides_2009, total_rides_2010, total_rides_2011 = 0, 0, 0, 0
total_hours, total_hours_2009, total_hours_2010, total_hours_2011 = 0.00, 0.00, 0.00, 0.00

# Variabled used to calculate the number of hours ridden
calc_hours, calc_minutes, calc_seconds, calc_miliseconds = 0, 0, 0, 0

# Variables to store training effect numbers
training_effect, training_effect_2009, training_effect_2010, training_effect_2011 = 0.0, 0.0, 0.0, 0.0

# Variables for average heart rate and peak heart rate.
avg_hr, peak_hr, avg_hr_2009, peak_hr_2009, avg_hr_2010, peak_hr_2010, avg_hr_2011, peak_hr_2011 = 0, 0, 0, 0, 0, 0, 0, 0

# Variables for energy expenditures
total_energy, energy_2009, energy_2010, energy_2011 = 0, 0, 0, 0

# Variables for max heart rate, energy distance and min distance
max_hr, max_energy, max_distance, min_distance = 0, 0, 0.0, 10000.0

# Search the specified directory for XML files. Then loop through
# each file for processing.
Dir.glob(DIRECTORY + "/*.xml") do |file|
  # get the year of this workout
  year = file.match(/20\d\d/).to_s
 
  # open the current XML document as a new REXML document object
  xml = Document.new(File.open(file))

  # reset calc_* time variables to 0 for each file
  calc_hours, calc_minutes, calc_seconds, calc_miliseconds = 0, 0, 0, 0
  
  # this loops through all the time elements
  # for workouts which have multiple 'laps'.
  xml.elements.each('//lap/time') do |ele|
    calc_hours += ele.text[0,2].to_i
    calc_minutes += ele.text[3,2].to_i
    calc_seconds += ele.text[6,2].to_i
    calc_miliseconds += ele.text[9,1].to_i
  end

  # grab other relevant data points not contained in lap elements.
  ahr = XPath.first(xml, "//average_heart_rate").text.to_i
  phr = XPath.first(xml, "//peak_heart_rate").text.to_i
  energy = XPath.first(xml, "//energy").text.to_i
  distance =  XPath.first(xml, "//distance")

  # check for the presences of the distance element
  # if this is nil then this workout was not a bike ride
  # so we won't process it.
  if distance
    d = distance.text.to_f # grab the numerical value of distance

    # total up energy and average and peak hear rates
    avg_hr += ahr
    peak_hr += phr
    total_energy += energy

    # set max_hr
    if phr > max_hr
      max_hr = phr
    end
  
    # set max energy
    if energy > max_energy
      max_energy = energy
    end

    # set max distance
    if d > max_distance
      max_distance = d
    end

    # set min distance
    if d < min_distance
      min_distance = d
    end


    # this will turn the HH:MM:SS:mm format time data into variables
    # representing actual hours, minutes, seconds and miliseconds.
    # if there are more than 10 miliseconds, 60 seconds or 60 minutes
    # it will add to the next higher up value 
    # ie: 65 minutes adds 1 to the hours value and leaves minutes
    #     set to 5
    miliseconds = calc_miliseconds % 10
    calc_seconds += calc_miliseconds / 10
    seconds = calc_seconds % 60
    calc_minutes += calc_seconds / 60
    minutes = calc_minutes % 60
    calc_hours += calc_minutes / 60
    hours = calc_hours
    
    # convert miliseconds, seconds and minutes to hours
    # then add them up with the hours to calculate the total.
    total_hours += (miliseconds / 10.0 / 60.0 / 60.0) + (seconds / 60.0 / 60.0) + (minutes / 60.0) + hours.to_f

    # increment total distance and total rides
    total_distance += d
    total_rides += 1

    # do similar calculations for specific years.
    case year
    when "2009"
      total_hours_2009 += (miliseconds / 10.0 / 60.0 / 60.0) + (seconds / 60.0 / 60.0) + (minutes / 60.0) + hours.to_f
      total_2009 += d
      total_rides_2009 += 1
      avg_hr_2009 += ahr
      peak_hr_2009 += phr
      energy_2009 += energy
    when "2010"
      total_hours_2010 += (miliseconds / 10.0 / 60.0 / 60.0) + (seconds / 60.0 / 60.0) + (minutes / 60.0) + hours.to_f
      total_2010 += d
      total_rides_2010 += 1
      avg_hr_2010 += ahr
      peak_hr_2010 += phr
      energy_2010 += energy
    when "2011"
      total_hours_2011 += (miliseconds / 10.0 / 60.0 / 60.0) + (seconds / 60.0 / 60.0) + (minutes / 60.0) + hours.to_f
      total_2011 += d
      total_rides_2011 += 1
      avg_hr_2011 += ahr
      peak_hr_2011 += phr
      energy_2011 += energy
    else
      puts "<p>Add case for #{year}</p>"
    end # end of case
  end # end of if distance
end # end of Dir.glob() each


# Output

printf("Cycling Statistics\n")
printf("==================\n\n")
printf("2009\n")
printf("----\n\n")
printf("Number of rides : %d\n", total_rides_2009)
printf("Distance        : %4.2f km\n", total_2009)
printf("Time            : %d hours\n", total_hours_2009.round)
printf("Energy          : %d kcal\n", energy_2009)
printf("Average Distance: %3.2f km\n", total_2009 / total_rides_2009)
printf("Average Time    : %2.1f hours\n", total_hours_2009 / total_rides_2009)
printf("Average Speed   : %2.1f km/h\n", total_2009 / total_hours_2009)
printf("Average Energy  : %d kcal\n", energy_2009 / total_rides_2009)
printf("Average HR      : %d\n", avg_hr_2009 / total_rides_2009)
printf("Average Peak HR : %d\n\n", peak_hr_2009 / total_rides_2009)
printf("2010\n")
printf("----\n\n")
printf("Number of rides : %d\n", total_rides_2010)
printf("Distance        : %4.2f km\n", total_2010)
printf("Time            : %d hours\n", total_hours_2010.round)
printf("Energy          : %d kcal\n", energy_2010)
printf("Average Distance: %3.2f km\n", total_2010 / total_rides_2010)
printf("Average Time    : %2.1f hours\n", total_hours_2010 / total_rides_2010)
printf("Average Speed   : %2.1f km/h\n", total_2010 / total_hours_2010)
printf("Average Energy  : %d kcal\n", energy_2010 / total_rides_2010)
printf("Average HR      : %d\n", avg_hr_2010 / total_rides_2010)
printf("Average Peak HR : %d\n\n", peak_hr_2010 / total_rides_2010)
printf("2011\n")
printf("----\n\n")
printf("Number of rides : %d\n", total_rides_2011)
printf("Distance        : %4.2f km\n", total_2011)
printf("Time            : %d hours\n", total_hours_2011.round)
printf("Energy          : %d kcal\n", energy_2011)
printf("Average Distance: %3.2f km\n", total_2011 / total_rides_2011)
printf("Average Time    : %2.1f hours\n", total_hours_2011 / total_rides_2011)
printf("Average Speed   : %2.1f km/h\n", total_2011 / total_hours_2011)
printf("Average Energy  : %d kcal\n", energy_2011 / total_rides_2011)
printf("Average HR      : %d\n", avg_hr_2011 / total_rides_2011)
printf("Average Peak HR : %d\n\n", peak_hr_2011 / total_rides_2011)
printf("Total\n")
printf("----\n\n")
printf("Number of rides : %d\n", total_rides)
printf("Distance        : %4.2f km\n", total_distance)
printf("Time            : %d hours\n", total_hours.round)
printf("Energy          : %d kcal\n", total_energy)
printf("Average Distance: %3.2f km\n", total_distance / total_rides)
printf("Average Time    : %2.1f hours\n", total_hours / total_rides)
printf("Average Speed   : %2.1f km/h\n", total_distance / total_hours)
printf("Average Energy  : %d kcal\n", total_energy / total_rides)
printf("Average HR      : %d\n", avg_hr / total_rides)
printf("Average Peak HR : %d\n", peak_hr / total_rides)
printf("Maximum Distance: %3.2f km\n", max_distance)
printf("Minimum Distance: %3.2f km\n", min_distance)
printf("Maximum Energy  : %d kcal\n", max_energy)
printf("Max Peak HR     : %d\n", max_hr)

