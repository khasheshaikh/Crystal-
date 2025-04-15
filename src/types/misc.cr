require "json"

module CrystalWeather
  module Types
    # `Conditions` represents the weather conditions for a specific location
    class Conditions
      # Time of the described conditions
      getter time : Time
      # Name of the conditions (Rain, snow, clouds...)
      getter name : String
      # Full description of the conditions
      getter description : String
      # URL to the PNG icon
      getter iconURL : String
      # Emoji associated to the conditions, based on the `CrystalWeather::CONDITION_EMOJIS` list
      getter emoji : Char

      # The temperature. Unit depends on the choosen units format :
      # - default : Kelvin
      # - metric : Celsius
      # - imperial : Fahrenheit
      getter temperature : Float64
      # The minimum temperature, for large areas such as megalopolises.
      # Uses the same unit as `#temperature`.
      getter minimum_temperature : Float64
      # The maximum temperature, for large areas such as megalopolises
      # Uses the same unit as `#temperature`.
      getter maximum_temperature : Float64
      # The atmospheric pressure, in hPa (1000 hPa = 1 bar)
      # It is on the sea level, if there is no sea_level or ground_level data
      getter pressure : Int32
      # The percentage of humidity in the air
      getter humidity : Int32

      # Clouds percentage in the sky
      getter clouds : Int32
      # Speed of the wind. Units depends on the choosen units format :
      # - default : meter/sec
      # - metric : meter/sec
      # - imperial : miles/hour
      getter wind_speed : Float64

      # Creates a new `Conditions` object based on the *data* sent by the API
      def initialize(data : JSON::Any)
        @time = Time.unix(data["dt"].as_i)
        @name = data["weather"][0]["main"].as_s
        @description = data["weather"][0]["description"].as_s
        @iconURL = "https://openweathermap.org/img/w/#{data["weather"][0]["icon"].as_s}.png"
        @emoji = CrystalWeather::CONDITION_EMOJIS[data["weather"][0]["icon"].as_s.gsub('n', 'd')]
      
        @temperature = data["main"]["temp"].as_f
        @minimum_temperature = data["main"]["temp_min"].as_f
        @maximum_temperature = data["main"]["temp_max"].as_f
        @pressure = data["main"]["pressure"].as_i
        @humidity = data["main"]["humidity"].as_i
        @clouds = data["clouds"]["all"].as_i
        @wind_speed = data["wind"]["speed"].as_f
      end
      def playlist_url : String
        case name.downcase
        when "clear"
          "https://open.spotify.com/playlist/37i9dQZF1DXdPec7aLTmlC"
        when "clouds"
          "https://open.spotify.com/playlist/37i9dQZF1DX889U0CL85jj"
        when "rain"
          "https://open.spotify.com/playlist/37i9dQZF1DXbvABJXBIyiY"
        when "snow"
          "https://open.spotify.com/playlist/37i9dQZF1DX2yvmlOdMYzV"
        when "thunderstorm"
          "https://open.spotify.com/playlist/37i9dQZF1DWZtZ8vUCzche"
        else
          "https://open.spotify.com/playlist/37i9dQZF1DWZjqjZMudx9T"
        end
      end
      
      def playlist_id : String
        playlist_url.split("/").last
      end
      
      
      
    end

    # `Coordinates` represents the coordinates of a specific location
    class Coordinates
      # Location's longitude
      getter longitude : Float64
      # Location's latitude
      getter latitude : Float64

      # Creates a new `Coordinates` object based on the *data* sent by the API
      def initialize(data : JSON::Any)
        @longitude = data["coord"]["lon"].as_f
        @latitude = data["coord"]["lat"].as_f
      end
    end

    # `City` represents the city in which the weather conditions occurs
    class City
      # City's name
      getter name : String
      # The code of the country in which the city is
      getter country_code : String
      # The timezone in which the city is (shift in seconds from UTC)
      getter timezone : Int32
      # The sunrise time in the city (UTC)
      getter sunrise : Time
      # The sunset time in the city (UTC)
      getter sunset : Time
      # The geolocation of the city
      getter coordinates : Coordinates

      # Creates a new `City` object based on the *city_data* sent by the API
      def initialize(name : String,
                     country_code : String,
                     timezone : Int32,
                     sunrise : Int32,
                     sunset : Int32,
                     coordinates : Coordinates)
        @name = name
        @country_code = country_code
        @timezone = timezone
        @sunrise = Time.unix(sunrise)
        @sunset = Time.unix(sunset)
        @coordinates = coordinates
      end
    end
  end
end
