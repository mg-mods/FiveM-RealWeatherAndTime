[ENG] How to change the arrangement in the UI with a few steps

1. Go to the file ui.html (it is in the html folder).

2. Look for the text

<body>
    <div id="ui">
        <div id="city" class="info"></div> 
        <div id="separator" class="info">|</div>
        <div id="time" class="info"></div>
        <div id="separator" class="info">|</div>
        <div id="weather" class="info">
            <i id="weather-icon" class="fas"></i>
            <span id="weather-text"></span>
        </div>
        <div id="separator" class="info">|</div>
        <div id="date" class="info"></div>
    </div>
    <script src="script.js"></script>
</body>
</html>

3. As an example, let's swap the city with the time. Then, write time in the city field and city in the time field. It should look like this:

<body>
    <div id="ui">
        <div id="time" class="info"></div> 
        <div id="separator" class="info">|</div>
        <div id="city" class="info"></div>
        <div id="separator" class="info">|</div>
        <div id="weather" class="info">
            <i id="weather-icon" class="fas"></i>
            <span id="weather-text"></span>
        </div>
        <div id="separator" class="info">|</div>
        <div id="date" class="info"></div>
    </div>
    <script src="script.js"></script>
</body>
</html>

4. That's it. Now restart L4-RealWeatherandUI once and it's done. You can change this with any value, such as time, city, weather, and date. Just keep two things in mind: If you want to move the weather, you need to move the three parts of the weather to make everything fit. The other thing is the separator lines. These are the lines to separate the respective fields, so don't change them.