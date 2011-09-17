class Resort < ActiveRecord::Base
  validates_uniqueness_of :name
  

  def resortforecast
    @resortforecast = Forecast.new(self)   
  end
  
  def resortSnowfall
    @resortSnowfall = Snowfall.new
  end
end
