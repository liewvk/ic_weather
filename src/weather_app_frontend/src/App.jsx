import React, { useState } from "react";
import { weather_app_backend } from "../../declarations/weather_app_backend";

const App = () => {
    const [city, setCity] = useState("");
    const [weather, setWeather] = useState(null);
    const [error, setError] = useState("");
    const [loading, setLoading] = useState(false);

    const fetchWeather = async () => {
        if (!city.trim()) {
            setError("Please enter a city name");
            return;
        }

        setLoading(true);
        setError("");
        
        try {
            const response = await weather_app_backend.getWeather(city);
            const weatherData = JSON.parse(response);
            setWeather(weatherData);
            setError("");
        } catch (err) {
            console.error("Error fetching weather:", err);
            setError("Failed to fetch weather data. Please try again.");
            setWeather(null);
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="app-container">
            <h1>🌤️ ICP Weather App</h1>
            <div className="search-container">
                <input
                    type="text"
                    placeholder="Enter city name"
                    value={city}
                    onChange={(e) => setCity(e.target.value)}
                    onKeyPress={(e) => e.key === 'Enter' && fetchWeather()}
                />
                <button onClick={fetchWeather} disabled={loading}>
                    {loading ? "Loading..." : "Get Weather"}
                </button>
            </div>

            {error && <p className="error">{error}</p>}

            {weather && (
                <div className="weather-info">
                    <h2>{weather.name}, {weather.sys.country}</h2>
                    <img
                        src={`https://openweathermap.org/img/wn/${weather.weather[0].icon}@2x.png`}
                        alt={weather.weather[0].description}
                    />
                    <p className="temperature">{Math.round(weather.main.temp)}°C</p>
                    <p className="description">{weather.weather[0].description}</p>
                    <div className="details">
                        <p>Humidity: {weather.main.humidity}%</p>
                        <p>Wind: {weather.wind?.speed || 0} m/s</p>
                    </div>
                </div>
            )}
        </div>
    );
};

export default App;