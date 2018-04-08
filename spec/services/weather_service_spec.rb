require 'rails_helper'

RSpec.describe WeatherService, type: :service do
  let (:json_object) { 
      {
        "coord"=> {
          "lon"=>-117.83, 
          "lat"=>33.69
        }, 
        "weather"=> [{
          "id"=>701, 
          "main"=>"Mist", 
          "description"=>"mist", 
          "icon"=>"50n"
        }], 
        "base"=>"stations", 
        "main"=>{
          "temp"=>58.98, 
          "pressure"=>1014, 
          "humidity"=>93, 
          "temp_min"=>55.4, 
          "temp_max"=>62.6
        }, 
        "visibility"=> 4828, 
        "wind" => {
          "speed"=>5.82, 
          "deg"=>310
        }, 
        "clouds"=> {
          "all"=>90
        }, 
        "dt"=>1523184000, 
        "sys"=> {
          "type"=>1, 
          "id"=>442, 
          "message"=>0.1671, 
          "country"=>"US", 
          "sunrise"=>1523194132, 
          "sunset"=>1523240254
        }, 
        "id"=>5359777, 
        "name"=>"Irvine", 
        "cod"=>200
      }
    }
  describe "#get_weather_by_city" do 
    it "should return temperature by city name" do 
      http_result = instance_double("HTTP::Response", body: json_object.to_json)
      allow(HTTP).to receive(:get).and_return(http_result)
      expect(WeatherService.get_weather_by_city("Example")).to eq({:name=>"Irvine", :temperature=>58.98})
    end

    it "should return empty hash if city is not found" do 
      http_result = instance_double("HTTP::Response", body: {"cod" => 404}.to_json)
      allow(HTTP).to receive(:get).and_return(http_result)
      expect(WeatherService.get_weather_by_city("Example")).to eq({})
    end
  end

  describe "#build_response" do 
    it "should return city name and temperature with response body" do 
      result = WeatherService.build_response(json_object)
      expect(result[:name]).to eq("Irvine")
      expect(result[:temperature]).to eq(58.98)
    end
  end
end
