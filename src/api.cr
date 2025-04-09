require "http"

module CrystalWeather
  # `API` is the interface that allows caller to interact with OpenWeatherMap's API
  class API
    # Choosen units format between :
    # default, metric or imperial
    getter units_format : String
    # Choosen lang between :
    # ar, bg, ca, cz, de, el, fa, fi, fr, gl, hr, hu, it, ja, kr, la, lt,
    # mk, nl, pl, pt, ro, ru, se, sk, sl, es, tr, ua, vi, zh_cn, zh_tw, en.
    getter lang : String

    # Creates a new `API` object. Please make sure that :
    # - you created an *api_key* on OpenWeatherMap's website
    # - the *lang* you choose is valid
    # - the *units_format* format you choose is valid
    def initialize(api_key : String, lang : String, units_format : String)
      @api_key = api_key

      raise Exceptions::UnknownLang.new("the lang #{lang} can't be accepted (please check the list of accepted langs on the documentation)") unless LANGS.includes? lang
      @lang = lang

      raise Exceptions::UnknownUnitsFormat.new("the units format #{units_format} can't be accepted (please check the list of accepted units on the documentation)") unless UNITS_FORMATS.includes? units_format
      @units_format = units_format
    end

    # Fetches the current weather for a specific *location*
    def current(location : String) : Types::Current
      data = raw_current(location)
      return Types::Current.new(data)
    end

    # Fetches the forecast for a specific *location*
    def forecast(location : String) : Types::Forecast
      data = raw_forecast(location)
      return Types::Forecast.new(data)
    end

    # Gets the raw data of the current weather for a specific *location*
    def raw_current(location : String) : JSON::Any
      return make_request("weather", location)
    end

    # Gets the raw data of the forecast for a specific *location*
    def raw_forecast(location : String) : JSON::Any
      return make_request("forecast", location)
    end

    # Makes a request to the OpenWeatherMap API, using the *type* of the request (forecast or weather) and a specific *location*
    private def make_request(type : String, location : String) : JSON::Any
      params = HTTP::Params.new
      params.add("APPID", @api_key)
      params.add("q", location)
      params.add("lang", @lang)
      params.add("units", @units_format)

      url = URI.parse("#{API_URL}/#{type}?#{params}")
      response = HTTP::Client.get(url)
      data = JSON.parse(response.body)

      if response.success?
        return data
      else
        api_status_text = "(API status : #{data["message"]})"
        case response.status_code
        when 404
          raise Exceptions::LocationNotFound.new("location #{location} wasn't found #{api_status_text}")
        when 401
          raise Exceptions::Unauthorized.new("the provided API key isn't valid #{api_status_text}")
        else
          raise Exceptions::UnknownAPIError.new("API returned an unknown error #{api_status_text}")
        end
      end
    end
  end
end
