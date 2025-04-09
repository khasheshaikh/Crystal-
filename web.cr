require "kemal"
require "./src/crystal-weather"

api = CrystalWeather::API.new(ENV["WEATHER_API_KEY"], "en", "metric")

get "/" do |env|
    <<-HTML
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8" />
      <title>Crystal Weather</title>
      <style>
        body {
          font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
          background: linear-gradient(to right, #dfe9f3, #ffffff);
          display: flex;
          justify-content: center;
          align-items: center;
          height: 100vh;
          margin: 0;
        }
  
        .card {
          background: white;
          padding: 2rem;
          border-radius: 1.5rem;
          box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
          text-align: center;
          max-width: 400px;
          width: 100%;
        }
  
        h1 {
          margin-bottom: 1rem;
          color: #333;
        }
  
        input[type="text"] {
          padding: 0.8rem;
          width: 80%;
          border: 1px solid #ccc;
          border-radius: 0.5rem;
          font-size: 1rem;
          margin-bottom: 1rem;
        }
  
        button {
          padding: 0.8rem 1.5rem;
          background-color: #3498db;
          color: white;
          border: none;
          border-radius: 0.5rem;
          cursor: pointer;
          font-size: 1rem;
        }
  
        button:hover {
          background-color: #2980b9;
        }
      </style>
    </head>
    <body>
      <div class="card">
        <h1>🌤 Crystal Weather</h1>
        <form action="/weather" method="get">
          <input type="text" name="city" placeholder="Enter a city" required>
          <br>
          <button type="submit">Get Weather</button>
        </form>
      </div>
    </body>
    </html>
    HTML
  end
  

get "/weather" do |env|
    city = env.params.query["city"]?
  
    if city
      begin
        raw = api.raw_current(city)
        puts raw.to_pretty_json
        weather = api.current(city)
        city_info = weather.city
        conditions = weather.conditions
  
        <<-HTML
            <!DOCTYPE html>
            <html lang="en">
            <head>
            <meta charset="UTF-8" />
            <title>Weather in #{city_info.name}</title>
            <style>
                body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(to right, #dfe9f3, #ffffff);
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
                }

                .card {
                background: white;
                padding: 2.5rem;
                border-radius: 1.5rem;
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
                text-align: center;
                max-width: 420px;
                width: 90%;
                }

                h2 {
                margin-top: 0;
                color: #2c3e50;
                }

                .emoji {
                font-size: 3rem;
                margin: 0.5rem 0;
                }

                p {
                margin: 0.5rem 0;
                font-size: 1.1rem;
                }

                .highlight {
                font-weight: bold;
                color: #2980b9;
                }

                a {
                display: inline-block;
                margin-top: 1.5rem;
                text-decoration: none;
                color: #3498db;
                font-weight: bold;
                }

                a:hover {
                text-decoration: underline;
                }
            </style>
            </head>
            <body>
            <div class="card">
                <h2>Weather in #{city_info.name}, #{city_info.country_code}</h2>
                <div class="emoji">#{conditions.emoji}</div>
                <p class="highlight">#{conditions.description.capitalize}</p>
                <p>🌡 Temperature: #{conditions.temperature}°C</p>
                <p>💧 Humidity: #{conditions.humidity}%</p>
                <p>💨 Wind: #{conditions.wind_speed} m/s</p>
                <a href="/">← Search another city</a>
            </div>
            </body>
            </html>
        HTML

      rescue e
        "<p>Error: #{e.message}</p><p><a href='/'>Try again</a></p>"
      end
    else
    env.redirect "/"

    end
  end
  

Kemal.run
