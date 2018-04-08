class WeathersController < ApplicationController

  def index

  end

  def show
    @result = WeatherService.get_weather_by_city(params[:city])
  end
end
