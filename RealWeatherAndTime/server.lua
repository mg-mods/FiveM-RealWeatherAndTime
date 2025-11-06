local apiKey = Config.ApiKey
local city = Config.City
local url = "http://api.openweathermap.org/data/2.5/weather?q=" .. string.gsub(city, " ", "%%20") .. "&appid=" .. apiKey .. "&units=metric"

Config = Config or {}
local configFile = LoadResourceFile(GetCurrentResourceName(), "config.lua")
assert(load(configFile))()

local function isPlayerAllowed(playerId)
    local identifiers = GetPlayerIdentifiers(playerId)
    for _, identifier in ipairs(identifiers) do
        for _, allowedIdentifier in ipairs(Config.AllowedPlayers) do
            if identifier == allowedIdentifier then
                return true
            end
        end
    end
    return false
end

RegisterNetEvent('checkAdminPermission')
AddEventHandler('checkAdminPermission', function()
    if Config.Debug then
        print("Player requested admin UI.")
    end
    local source = source
    if isPlayerAllowed(source) then
        if Config.Debug then
            print("Player allowed, opening admin UI.")
        end
        TriggerClientEvent('openAdminUI', source)
    else
        if Config.Debug then
            print("Unauthorized: access denied.")
        end
        TriggerClientEvent('noPermission', source)
    end
end)

RegisterNetEvent('triggerTimeUpdate')
AddEventHandler('triggerTimeUpdate', function()
    if Config.Debug then
        print("Player requested time update.")
    end
    local source = source
    if isPlayerAllowed(source) then
        if Config.Debug then
            print("Player allowed, updating time.")
        end
        getWeather()
    else
        if Config.Debug then
            print("Unauthorized: access denied.")
        end
        TriggerClientEvent('noPermission', source)
    end
end)

local lastWeather = nil
local timeZone = 0
local dstOffset = 0

function getWeather()
    if Config.Debug then
        print("Sending API request:", url)
    end
    PerformHttpRequest(url, function(statusCode, response, headers)
        if statusCode == 200 then
            -- Get Weather infos
            local weatherData = json.decode(response)
            local weather = weatherData.weather[1].main
            local windSpeed = weatherData.wind.speed
            local windDirection = weatherData.wind.deg

            -- Get Time infos
            timeZone = weatherData.timezone
            local currentTimestamp = os.time()
            local localTime = weatherData.dt + weatherData.timezone
            local localTimestamp = currentTimestamp - localTime
            local time = os.date("!*t", localTimestamp)
            local timestamp = {
                hours = time.hour,
                min = time.min,
                sec = time.sec
            }

            -- Get DST infos
            local localUtcTime = os.date("*t", currentTimestamp)
            local utcTime = os.date("!*t", currentTimestamp)
            dstOffset = localUtcTime.hour - utcTime.hour

            TriggerClientEvent('updateWeatherAndWind', -1, weather, windSpeed, windDirection)
            TriggerClientEvent('updateTime', -1, timestamp.hours, timestamp.min, timestamp.sec)

            if Config.Debug then
                print("API request successful.")
            end
        else
            print("Error in HTTP request: " .. statusCode)
        end
    end, "GET", "", {
        ["Content-Type"] = "application/json"
    })
end

function updateTime()

    local localTimestamp = os.time(os.date("!*t")) + timeZone

    local time = os.date("!*t", localTimestamp)

    local timestamp = {
        hours = time.hour + dstOffset,
        min = time.min,
        sec = time.sec
    }

    if Config.Debug then
        print("Updating time: ", timestamp.hours, "h ", timestamp.min, "min ", timestamp.sec, "sec")
    end
    TriggerClientEvent('updateTime', -1, timestamp.hours, timestamp.min, timestamp.sec)
end

Citizen.CreateThread(function()
    while true do
        getWeather()
        Citizen.Wait(Config.UpdateInterval)
        if Config.Debug then
            print("Update interval timeout, sending request to API.")
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        updateTime()
        Citizen.Wait(1000)
    end
end)
RegisterNetEvent('saveBlackoutSettings')
AddEventHandler('saveBlackoutSettings', function(fullBlackout)
    TriggerClientEvent('updateBlackoutSettings', -1, fullBlackout)
end)
