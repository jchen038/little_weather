class WeatherService
  UNIT_TYPE = "imperial"

  class << self
    def get_weather_by_city(city)
      url = "#{APP_CONFIG["api_url"]}/weather"

      response = HTTP.get(url, params: {q: city, appid: APP_CONFIG["api_key"], units: UNIT_TYPE})
      json_body = JSON.parse(response.body.to_s)
      json_body

      json_body["cod"] && json_body["cod"] == 200 ? build_response(json_body) : {}
    end

    def build_response(json)
      {
        name: json["name"],
        temperature: json["main"]["temp"]
      }
    end
  end
end