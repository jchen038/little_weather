class WeatherService
  UNIT_TYPE = "imperial"

  class << self
    def get_weather_by_city(city)
      temperature = Slug[city.downcase] 
      if temperature.nil?
        Rails.logger.info("FROM API")
        fetch_from_api(city) 
      else 
        Rails.logger.info("FROM Redis")
        Weather.new({location: city, temperature: temperature})
      end
    end

    def fetch_from_api(city)
      url = "#{APP_CONFIG["api_url"]}/weather"

      response = HTTP.get(url, params: {q: city, appid: APP_CONFIG["api_key"], units: UNIT_TYPE})
      json_body = JSON.parse(response.body.to_s)

      weather = build_object(json_body)
      
      save_me(weather) unless weather.is_blank?

      weather
    end

    def build_object(json)
      if json["cod"] && json["cod"] == 200
        return Weather.new({location:json["name"], temperature: json["main"]["temp"]})
      else 
        return Weather.new()
      end
    end

    def save_me(weather)
      Slug[weather.location.downcase] = weather.temperature
      true
    end
    
    def remove_me(weather)
      Slug.destroy(weather.location)
      true
    end
  end
end