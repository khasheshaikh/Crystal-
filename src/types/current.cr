require "json"

module CrystalWeather
  module Types
    class Current
      # City where the weather conditions applies
      getter city : City
      # Details of the weather conditions
      getter conditions : Conditions

      # Creates a new `Current` object based on the *data* sent by the API
      def initialize(data : JSON::Any)
        @city = City.new(
          name: data["name"].as_s,
          country_code: data["sys"]["country"].as_s,
          timezone: data["timezone"].as_i,
          sunrise: data["sys"]["sunrise"].as_i,
          sunset: data["sys"]["sunset"].as_i,
          coordinates: Coordinates.new(data)
        )
        @conditions = Conditions.new(data)
      end
    end
  end
end
