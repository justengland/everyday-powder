require 'net/http'
require 'uri'


# Use Bundler http://gembundler.com/
require 'rubygems'
require 'nokogiri'
require 'open-uri'


class Forecast
  
  def initialize resort
      @resort = resort
      @forecastXml = getforecast(@resort.lat, @resort.long)  
  end
  
  attr_accessor :forecastUrl

  # worded forecast <wordedForecast time-layout="k-p12h-n13-1" 
  def description    
    getDescription() 
  end
 
  def forecastTimes
    # Get the full 12 hour forcast times 
    # <time-layout time-coordinate="local" summarization="12hourly">
    #   <layout-key>k-p12h-n13-1</layout-key>
    #   <start-valid-time period-name="Today">2011-07-17T06:00:00-07:00</start-valid-time>    
    startTimes = @forecastXml.xpath("//time-layout[layout-key = 'k-p12h-n13-1']/./start-valid-time")
    dayStartTimes = @forecastXml.xpath("//time-layout[layout-key = 'k-p24h-n7-1']/./start-valid-time")
    nightStartTimes = @forecastXml.xpath("//time-layout[layout-key = 'k-p24h-n6-2']/./start-valid-time")
    
    #Get elements
    forecastIconsElements = @forecastXml.xpath("//conditions-icon[@type='forecast-NWS']/icon-link")
    wordedForecastElements = @forecastXml.xpath("//wordedForecast/text")
    forecastMaxElements = @forecastXml.xpath("//temperature[@type='maximum']/value")
    forecastMinElements = @forecastXml.xpath("//temperature[@type='minimum']/value")
    
    forecastSegments = []
    dayIndex = 0
    nightIndex = 0
    startTimes.length.times do |i|
      currentStartTime = startTimes.at(i)
      sample = ''
        
      if currentStartTime != ''
        currentTimePeriod = currentStartTime.attr('period-name')
        tempForecast = 'not-set'
       
        
        if containsTimePeriod(dayStartTimes, currentTimePeriod)
          # Day Forecast
          tempForecast = forecastMaxElements.at(dayIndex)
          if tempForecast != nil
            tempForecast = forecastMaxElements.at(dayIndex).text
          end
          dayIndex += 1
        else
          # Night Forcast
          tempForecast = forecastMinElements.at(nightIndex)
          if tempForecast != nil
            tempForecast = forecastMinElements.at(nightIndex).text
          end
          nightIndex += 1
        end        
      end
      # Find the result object members
      icon = forecastIconsElements.at(i).text  
      worded = wordedForecastElements.at(i).text
      
      # Build out the result object
      #  attr_accessor :desc, :precipitationProbability, :summary, :tempForecast, :maxTemp, :minTemp, :weatherIcon      
      forecastTime = ForecastSegment.new
      forecastTime.maxTemp = 'hot'
      #forecastTime.minTemp = sample
      forecastTime.tempForecast = tempForecast
      forecastTime.weatherIcon = icon
      forecastTime.desc = worded
      #forecastTime.summary = 'day: ' + dayStartTimes.length.to_s + ' night: ' + nightStartTimes.length.to_s
      #forecastTime.summary = 'dayIndex: ' + dayIndex.to_s + ' -- ' + sample
      forecastTime.title = currentTimePeriod
      forecastSegments.push(forecastTime)
            
    end
    
    return forecastSegments
    
    
  end
  
  def containsTimePeriod(elements, checkTimePeriod)
   # result = ' [[ ' + checkTimePeriod + ' equals - '
    elements.each do |timeElement|
      timePeriod = timeElement.attr('period-name')
      
      if timePeriod == checkTimePeriod
        return true
        #result += ' [ '
        #result += timePeriod
        #result += ' ] ]] '
        #return result
      #else
        #result += ' '
        #result += timePeriod
        #result += ' '        
      end            
    end
      
    return false
   
  end
  
  def getforecast(latitude, longitude)
    #http://forecast.weather.gov/MapClick.php?lat=39.63&lon=-106.37&FcstType=dwml
    @forecastUrl = "http://forecast.weather.gov/MapClick.php?lat=" + latitude.to_s() + "&lon=" + longitude.to_s() + "&FcstType=dwml"
    forecastUri = URI.parse(@forecastUrl)
    response = Net::HTTP.get_response(forecastUri)
    dwmlDoc = Nokogiri::XML(response.body)
    
    #parseforecast(response.body)
    #forecastUrl    
  end
  
  # parse the description from @forecastXml
  def getDescription()
    @forecastXml.xpath("//description").first.text
  end
  
end

# why I not have this class in another file?
class ForecastSegment
  
  attr_accessor :desc,
                :precipitationProbability,
                :summary,
                :tempForecast, 
                :title,               
                :maxTemp, 
                :minTemp, 
                :weatherIcon

  
end
