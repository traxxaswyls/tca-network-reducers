//
//  WeatherState.swift
//  ParameterReloadableExample
//
//  Created by Gleb Kovalenko on 30.07.2023.
//

import Models
import Foundation

// MARK: - WeatherState

public struct WeatherState: Equatable {
    
    // MARK: - Properties
    
    /// Timestamp
    public let timestamp: Date
    
    /// Temperature in Celsius
    public let temperature: Int
    
    /// Atmospheric pressure in hPa
    public let pressure: Int
    
    /// Humidity %
    public let humidity: Int
    
    /// Wind speed  in m/s
    public let windSpeed: Double
    
    // MARK: - Initializer
    
    public init(
        timestamp: Date,
        temperature: Int,
        pressure: Int, 
        humidity: Int,
        windSpeed: Double
    ) {
        self.timestamp = timestamp
        self.temperature = temperature
        self.pressure = pressure
        self.humidity = humidity
        self.windSpeed = windSpeed
    }
}

// MARK: - Initializer

extension WeatherState {
    
    public init(plain: WeatherByCoordsPlainObject) {
        self.timestamp = plain.weather.timestamp
        self.temperature = plain.weather.temperature
        self.pressure = plain.weather.pressure
        self.humidity = plain.weather.humidity
        self.windSpeed = plain.weather.windSpeed
    }
}
