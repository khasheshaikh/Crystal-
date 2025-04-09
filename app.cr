require "./src/crystal-weather"

# Replace with your actual API key from OpenWeatherMap
api_key = "d23635b8e0cf0de68c743cbabb10e5aa"

# Create API instance 
api = CrystalWeather::API.new(
  api_key, 
  "en",     # Language (English)
  "metric"  # Units format (Celsius)
)

# Use the API
puts "Fetching weather for London..."
begin
  current = api.current("London")
  
  # Access weather information using the correct structure
  puts "Location: #{current.city.name}, #{current.city.country_code}"
  puts "Temperature: #{current.conditions.temperature}°C"
  puts "Weather: #{current.conditions.name} - #{current.conditions.description} #{current.conditions.emoji}"
  puts "Humidity: #{current.conditions.humidity}%"
  puts "Wind Speed: #{current.conditions.wind_speed} m/s"
  puts "Pressure: #{current.conditions.pressure} hPa"
  puts "Updated at: #{current.conditions.time}"
rescue ex
  puts "Error: #{ex.message}"
end