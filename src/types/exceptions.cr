module CrystalWeather
  # `Exception` is the base exception for the `CrystalWeather` library
  class Exception < ::Exception
  end

  # Module `Exceptions` contains all the exceptions that the library can raise if an error occurs
  module Exceptions
    # `UnknownLang` informs that the caller used a lang that isn't recognized
    class UnknownLang < CrystalWeather::Exception
    end

    # `UnknownUnitsFormat` informs that the caller used a unit system that isn't recognized
    class UnknownUnitsFormat < CrystalWeather::Exception
    end

    # `Unauthorized` informs that caller's key is wrong, so it cannot access to the API
    class Unauthorized < CrystalWeather::Exception
    end

    # `LocationNotFound` informs that the location provided by the caller wasn't found
    class LocationNotFound < CrystalWeather::Exception
    end

    # `APIError` informs that an unknown error was thrown by the API
    class UnknownAPIError < CrystalWeather::Exception
    end
  end
end
