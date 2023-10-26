//
//  WeatherByCoordsService.swift
//  BusinessLayer
//
//  Created by Gleb Kovalenko on 30.07.2023.
//

import Models
import ServiceCore

// MARK: - WeatherByCoordsServiceAction

public enum WeatherByCoordsServiceAction: Equatable {
    
    // MARK: - Cases
    
    case weatherObtained(WeatherByCoordsPlainObject)
}

// MARK: - WeatherByCoordsService

public protocol WeatherByCoordsService {
    
    /// Obtain weather in given coordinates
    /// - Parameter coords: place coordinates
    /// - Returns: weather plain object
    func obtainWeather(coords: CoordinatesPlainObject) -> ServiceCall<WeatherByCoordsPlainObject>
    
    /// Read weather in given coordinates from local db
    /// - Parameter coords: place coordinates
    /// - Returns: weather plain object
    func readWeather(coords: CoordinatesPlainObject) -> ServiceCall<WeatherByCoordsPlainObject?>
}
