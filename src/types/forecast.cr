require "json"

module CrystalWeather
  module Types
    class Forecast
      # City where the weather conditions applies
      getter city : City
      # Details of the forecast
      getter conditions : Array(Conditions)

      # Creates a new `Forecast` object based on the *data* sent by the API
      def initialize(data : JSON::Any)
        @city = City.new(
          name: data["city"]["name"].as_s,
          country_code: data["city"]["country"].as_s,
          timezone: data["city"]["timezone"].as_i,
          sunrise: data["city"]["sunrise"].as_i,
          sunset: data["city"]["sunset"].as_i,
          coordinates: Coordinates.new(data["city"])
        )
        @conditions = [] of Conditions
        data["list"].as_a.each do |condition|
          @conditions << Conditions.new(condition)
        end
      end
    end
  end
end
