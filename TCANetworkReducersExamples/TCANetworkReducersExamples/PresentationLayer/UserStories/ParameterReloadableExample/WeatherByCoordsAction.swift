//
//  WeatherByCoordsAction.swift
//  ParameterReloadableExample
//
//  Created by Gleb Kovalenko on 30.07.2023.
//

import TCANetworkReducers
import Models

// MARK: - WeatherByCoordsAction

public enum WeatherByCoordsAction: Equatable {
    
    // MARK: - Cases
    
    /// General action that calls when view appears
    case onAppear
    
    /// An action that calls when entered longitude has changed
    case longitudeChanged(String)
    
    /// An action that calls when entered latitude has changed
    case latitudeChanged(String)
    
    /// An action that calls when user taps on the `GetWeather` button
    case getWeatherButtonTapped
    
    /// An action that calls when user taps on the `dismiss` button on the alert
    case alertDismissed
    
    // MARK: - Relodable
    
    /// Relodable action
    case reloadableWeatherByCoords(ReloadableAction<WeatherByCoordsPlainObject, WeatherByCoordsError>)
}
