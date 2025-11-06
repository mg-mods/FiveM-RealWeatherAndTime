Config = {}

--Change API and City here; if you need help read the README
Config.ApiKey = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" -- Your API key from openweathermap.org 

-- Go to https://openweathermap.org, search your city and copy the name here
-- Example names to use: "Los Angeles", "Chicago", "New York", "London", "Paris", "Berlin", "Rome"
Config.City = "Los Angeles"

-- Change AllowedPlayers here; if you need help read the README
Config.AllowedPlayers = {
    "fivem:0000000",
}

-- Change UpdateInterval and TransitionTime here if you need help read the README. 
-- The settings are still in beta, please do not change them unless you have knowledge about it.
Config.UpdateInterval = 360000 -- in ms, 360000 (6 min) by default

-- UI Configurations
Config.ShowCity = false-- Show the city in the WeatherUI
Config.ShowTime = true -- Show the time in the WeatherUI
Config.ShowWeather = true -- Show the weather in the WeatherUI
Config.ShowDate = true -- Show the date in the WeatherUI
Config.ShowUI = false -- Show the WeatherUI in the game
Config.UIPosition = 'top-left' -- Position des UI: 'top-left', 'top-right','center', 'bottom-left', 'bottom-center', 'bottom-right'
Config.DraggableUI = true -- Enable/Disable draggable UI command is '/moveui' 

-- Debug-Mode (will display a lot of stuff so only turn on if necessary)
Config.Debug = false
