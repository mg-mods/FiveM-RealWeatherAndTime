Config = Config or {}
local configFile = LoadResourceFile(GetCurrentResourceName(), "config.lua")
assert(load(configFile))()

local currentWeather = "OVERCAST"
local newWeather = "OVERCAST"
local time = {
    hours = 12,
    minutes = 0,
    seconds = 0
}
local transitionTime = 240
local isDragging = false
local originalPosition = {
    left = "0px",
    top = "0px"
}

-- Translations for Weather-Types 
-- English Translations (Uncomment to use)
local WeatherTranslations = {
    ["CLEAR"] = "Clear",
    ["EXTRASUNNY"] = "Extra Sunny",
    ["CLOUDS"] = "Clouds",
    ["OVERCAST"] = "Overcast",
    ["RAIN"] = "Rain",
    ["CLEARING"] = "Clearing",
    ["THUNDER"] = "Thunder",
    ["SMOG"] = "Smog",
    ["FOGGY"] = "Foggy",
    ["XMAS"] = "Snow",
    ["SNOWLIGHT"] = "Light Snow",
    ["BLIZZARD"] = "Blizzard",
    ["SNOW"] = "Snow",
    ["HALLOWEEN"] = "Halloween"
}
-- French Translations (Uncomment to use)
--[[
WeatherTranslations = {
    ["CLEAR"] = "Clair",
    ["EXTRASUNNY"] = "Très ensoleillé",
    ["CLOUDS"] = "Nuageux",
    ["OVERCAST"] = "Couvert",
    ["RAIN"] = "Pluvieux",
    ["CLEARING"] = "Dégagé",
    ["THUNDER"] = "Orageux",
    ["SMOG"] = "Brouillard",
    ["FOGGY"] = "Brumeux",
    ["XMAS"] = "Neige",
    ["SNOW"] = "Neige",
    ["SNOWLIGHT"] = "Neige légère",
    ["BLIZZARD"] = "Blizzard",
    ["HALLOWEEN"] = "Halloween"
}
]]
-- German Translations (Uncomment to use)
--[[
WeatherTranslations = {
    ["CLEAR"] = "Klar",
    ["EXTRASUNNY"] = "Sonnig",
    ["CLOUDS"] = "Bewölkt",
    ["OVERCAST"] = "Stark bewölkt",
    ["RAIN"] = "Regen",
    ["CLEARING"] = "Bewölkt",
    ["THUNDER"] = "Gewitter",
    ["SMOG"] = "Smog",
    ["FOGGY"] = "Nebelig",
    ["XMAS"] = "Schnee",
    ["SNOWLIGHT"] = "Leichter Schnee",
    ["BLIZZARD"] = "Schneesturm",
    ["SNOW"] = "Schnee",
    ["HALLOWEEN"] = "Halloween"
}
]]
-- Spanish Translations (Uncomment to use)
--[[
WeatherTranslations = {
    ["CLEAR"] = "Despejado",
    ["EXTRASUNNY"] = "Muy soleado",
    ["CLOUDS"] = "Nublado",
    ["OVERCAST"] = "Muy nublado",
    ["RAIN"] = "Lluvia",
    ["CLEARING"] = "Despejando",
    ["THUNDER"] = "Tormenta",
    ["SMOG"] = "Smog",
    ["FOGGY"] = "Nebuloso",
    ["XMAS"] = "Nieve",
    ["SNOWLIGHT"] = "Nieve ligera",
    ["BLIZZARD"] = "Ventisca",
    ["SNOW"] = "Nieve",
    ["HALLOWEEN"] = "Halloween"
}
]]
-- Dutch Translations (Uncomment to use)
--[[
WeatherTranslations = {
    ["CLEAR"] = "Helder",
    ["EXTRASUNNY"] = "Zonnig",
    ["CLOUDS"] = "Bewolkt",
    ["OVERCAST"] = "Zwaar bewolkt",
    ["RAIN"] = "Regen",
    ["CLEARING"] = "Opklarend",
    ["THUNDER"] = "Onweer",
    ["SMOG"] = "Smog",
    ["FOGGY"] = "Mistig",
    ["XMAS"] = "Sneeuw",
    ["SNOWLIGHT"] = "Lichte sneeuw",
    ["BLIZZARD"] = "Sneeuwstorm",
    ["SNOW"] = "Sneeuw",
    ["HALLOWEEN"] = "Halloween"
}
]]
-- Polish Translations (Uncomment to use)
--[[
WeatherTranslations = {
    ["CLEAR"] = "Czyste",
    ["EXTRASUNNY"] = "Bardzo słonecznie",
    ["CLOUDS"] = "Chmury",
    ["OVERCAST"] = "Zachmurzenie",
    ["RAIN"] = "Deszcz",
    ["CLEARING"] = "Przejaśnienia",
    ["THUNDER"] = "Burza",
    ["SMOG"] = "Smog",
    ["FOGGY"] = "Mglisto",
    ["XMAS"] = "Śnieg",
    ["SNOWLIGHT"] = "Lekki śnieg",
    ["BLIZZARD"] = "Zamieć",
    ["SNOW"] = "Śnieg",
    ["HALLOWEEN"] = "Halloween"
}
]]

-- Update weather and wind event
RegisterNetEvent('updateWeatherAndWind')
AddEventHandler('updateWeatherAndWind', function(weather, windSpeed, windDirection)
    if Config.Debug then
        print("Received Weather Data: " .. weather)
        print("Received WindSpeed Data: " .. windSpeed)
        print("Received WindDirection Data: " .. windDirection)
    end
    if weather == "Clear" then
        newWeather = "CLEAR"
    elseif weather == "Extrasunny" then
        newWeather = "EXTRASUNNY"
    elseif weather == "Clouds" then
        newWeather = "CLOUDS"
    elseif weather == "Overcast" then
        newWeather = "OVERCAST"
    elseif weather == "Rain" then
        newWeather = "RAIN"
    elseif weather == "Clearing" then
        newWeather = "CLEARING"
    elseif weather == "Thunder" then
        newWeather = "THUNDER"
    elseif weather == "Smog" then
        newWeather = "SMOG"
    elseif weather == "Foggy" then
        newWeather = "FOGGY"
    elseif weather == "Xmas" then
        newWeather = "XMAS"
    elseif weather == "Snowlight" then
        newWeather = "SNOWLIGHT"
    elseif weather == "Blizzard" then
        newWeather = "BLIZZARD"
    elseif weather == "Snow" then
        newWeather = "SNOW"
    elseif weather == "Halloween" then
        newWeather = "HALLOWEEN"
    else
        newWeather = "CLEAR"
    end

    SetWindSpeed(windSpeed)
    SetWindDirection(windDirection)
end)

-- setWeather
local function setWeather(weather)
    ClearOverrideWeather()
    ClearWeatherTypePersist()
    SetWeatherTypePersist(weather)
    SetWeatherTypeNow(weather)
    SetWeatherTypeNowPersist(weather)
end

-- Update weather thread
CreateThread(function()
    setWeather("OVERCAST")
    while true do
        if currentWeather ~= newWeather then
            if Config.Debug then
                print("Changing Weather from " .. currentWeather .. " to " .. newWeather .. " in " .. transitionTime .. " seconds.")
            end
            currentWeather = newWeather
            SetWeatherTypeOvertimePersist(currentWeather, 240.0)
            Wait((transitionTime / 4) * 1000)
        end
        setWeather(currentWeather)
        Wait(1000)
    end
end)

-- Update time event
RegisterNetEvent('updateTime')
AddEventHandler('updateTime', function(hour, minute, second)
    time.hours = hour
    time.minutes = minute
    time.seconds = second
    if Config.Debug then
        print('New time:', hour, minute, second)
    end
end)

-- Set UI position event
RegisterNetEvent('setUIPosition')
AddEventHandler('setUIPosition', function(position)
    SendNUIMessage({
        action = 'setPosition',
        left = position.left,
        top = position.top
    })
end)

-- Clock override thread
CreateThread(function()
    while true do
        NetworkOverrideClockTime(time.hours, time.minutes, time.seconds)
        Wait(0)
    end
end)

-- Display time command
RegisterCommand('time', function()
    local hours = time.hours
    local minutes = time.minutes
    local seconds = time.seconds
    TriggerEvent('chat:addMessage', {
        color = {255, 255, 255},
        multiline = true,
        args = {"It is currently ", string.format("%02d:%02d:%02d", hours, minutes, seconds), " in ", Config.City}
    })
end, false)

-- Move UI command
RegisterCommand('moveui', function()
    if Config.DraggableUI then
        TriggerEvent('esx:showNotification',
            "UI verschieben aktiviert. Drücke Enter, um zu speichern, oder Esc, um abzubrechen.")
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "enableDrag"
        })
    end
end, false)

-- Update UI thread
CreateThread(function()
    while true do
        local currentDate = GetCurrentDate()
        if Config.ShowUI then
            SendNUIMessage({
                action = 'updateUI',
                showCity = Config.ShowCity,
                city = Config.City,
                showTime = Config.ShowTime,
                time = string.format("%02d:%02d", time.hours, time.minutes),
                showDate = Config.ShowDate,
                date = currentDate,
                showWeather = Config.ShowWeather,
                weather = WeatherTranslations[currentWeather] or currentWeather,
                draggable = Config.DraggableUI,
                uiPosition = Config.UIPosition
            })
        else
            SendNUIMessage({
                action = 'hideUI'
            })
        end
        Wait(1000)
    end
end)

-- Get date function
function GetCurrentDate()
    local year, month, day = GetLocalTime()
    return string.format("%02d.%02d.%04d", day, month, year)
end

-- Blackout settings event
RegisterNetEvent('updateBlackoutSettings')
AddEventHandler('updateBlackoutSettings', function(fullBlackout)
    if (fullBlackout) then
        SetArtificialLightsState(true)
        SetArtificialLightsStateAffectsVehicles(true)
    else
        SetArtificialLightsState(false)
        SetArtificialLightsStateAffectsVehicles(false)
    end
end)

-- Open admin UI command
RegisterCommand('adminweatherui', function()
    TriggerServerEvent('checkAdminPermission')
end, false)

-- Sync weather and time command
RegisterCommand('syncWeatherTime', function()
    TriggerServerEvent('triggerTimeUpdate')
end, false)

-- Open admin UI event
RegisterNetEvent('openAdminUI')
AddEventHandler('openAdminUI', function()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'showAdminUI'
    })
end)

-- Unauthorized access event
RegisterNetEvent('noPermission')
AddEventHandler('noPermission', function()
    TriggerEvent('chat:addMessage', {
        color = {255, 0, 0},
        multiline = true,
        args = {"System", "Du hast keine Berechtigung, diesen Befehl auszuführen."}
    })
end)

-- Display debug infos event, dev tool only
RegisterNetEvent('debugDisplay')
AddEventHandler('debugDisplay', function(content)
    print('Debug:', content)
end)

-- NUI Callbacks
RegisterNUICallback('savePosition', function(data, cb)
    TriggerServerEvent('saveUIPosition', data.left, data.top)
    SetNuiFocus(false, false)
    cb('ok')
end)
RegisterNUICallback('nuiFocusOff', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)
RegisterNUICallback('setOriginalPosition', function(data, cb)
    originalPosition.left = data.left
    originalPosition.top = data.top
    cb('ok')
end)
RegisterNUICallback('resetPosition', function(data, cb)
    SendNUIMessage({
        action = 'setPosition',
        left = originalPosition.left,
        top = originalPosition.top
    })
    SetNuiFocus(false, false)
    cb('ok')
end)
RegisterNUICallback('closeAdminUI', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)
RegisterNUICallback('updateBlackout', function(data, cb)
    TriggerServerEvent('saveBlackoutSettings', data.fullBlackout)
    cb('ok')
end)

