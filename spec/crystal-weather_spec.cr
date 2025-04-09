require "./spec_helper"

describe CrystalWeather do
  describe CrystalWeather::API do
    describe "#new" do
      it "should create an API instance" do
        api = CrystalWeather::API.new(ENV["WEATHER_API_KEY"], "fr", "metric")
        api.should be_a CrystalWeather::API
        api.lang.should eq "fr"
        api.units_format.should eq "metric"
      end

      it "should raise an unknown lang exception" do
        expect_raises(CrystalWeather::Exceptions::UnknownLang) do
          api = CrystalWeather::API.new(ENV["WEATHER_API_KEY"], "hello", "metric")
        end
      end

      it "should raise an unknown unit exception" do
        expect_raises(CrystalWeather::Exceptions::UnknownUnitsFormat) do
          api = CrystalWeather::API.new(ENV["WEATHER_API_KEY"], "fr", "hello")
        end
      end
    end

    describe "#raw_current" do
      it "should get the raw current weather data" do
        api = CrystalWeather::API.new(ENV["WEATHER_API_KEY"], "fr", "metric")
        data = api.raw_current("Lyon,FR")
        data.should be_a(JSON::Any)
      end

      it "should raise an unknown location error" do
        expect_raises(CrystalWeather::Exceptions::LocationNotFound) do
          api = CrystalWeather::API.new(ENV["WEATHER_API_KEY"], "fr", "metric")
          api.raw_current("Washington,FR")
        end
      end

      it "should raise an unauthorized key error" do
        expect_raises(CrystalWeather::Exceptions::Unauthorized) do
          api = CrystalWeather::API.new("sample key", "fr", "metric")
          api.raw_current("Lyon,FR")
        end
      end
    end

    describe "#raw_forecast" do
      it "should get the raw forecast data" do
        api = CrystalWeather::API.new(ENV["WEATHER_API_KEY"], "fr", "metric")
        data = api.raw_forecast("Lyon,FR")
        data.should be_a(JSON::Any)
      end
    end

    describe "#current" do
      it "should return a CrystalWeather::Types::Current" do
        api = CrystalWeather::API.new(ENV["WEATHER_API_KEY"], "fr", "metric")
        data = api.current("Lyon,FR")
        data.should be_a(CrystalWeather::Types::Current)
      end
    end

    describe "#forecast" do
      it "should return a CrystalWeather::Types::Forecast" do
        api = CrystalWeather::API.new(ENV["WEATHER_API_KEY"], "fr", "metric")
        data = api.forecast("Lyon,FR")
        data.should be_a(CrystalWeather::Types::Forecast)
      end
    end
  end
end
