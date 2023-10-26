//
//  WeatherByCoordsState.swift
//  ParameterReloadableExample
//
//  Created by Gleb Kovalenko on 30.07.2023.
//

import TCANetworkReducers
import CoreLocation
import Models
import TCA

// MARK: - WeatherByCoordsState

public struct WeatherByCoordsState: Equatable {
    
    // MARK: - WeatherByCoordsResponse
    
    public enum WeatherByCoordsResponse {
        
        // MARK: - Cases
        
        case none
        case network
        case cache
        
        // MARK: - Useful
        
        public var message: String? {
            switch self {
            case .none:
                return nil
            case .network:
                return "This is network response"
            case .cache:
                return "This is cache response"
            }
        }
    }
    
    // MARK: - Properties
    
    /// Entered latitude
    public var enteredLatitude = "35.95633"
    
    /// Entered longitude
    public var enteredLongitude = "140.32356"
    
    /// Indicates which response is got(just for clarity)
    public var weatherByCoordsResponse: WeatherByCoordsResponse = .none
    
    /// Found city
    public var city = ""
    
    /// Found state
    public var cityState = ""
    
    /// Found country
    public var country = ""
    
    /// Found weather
    public var weather: WeatherState
    
    /// Alert state value
    public var alert: AlertState<WeatherByCoordsAction>?
    
    /// Indicates which `GetWeather` button active
    public var isGetWeatherButtonActive: Bool {
        reloadableWeatherByCoords.status != .loading && reloadableWeatherByCoords.status != .reloading
    }
    
    // MARK: - Relodable
    
    /// Reloadable state instance
    public var reloadableWeatherByCoords: ParameterReloadableState<WeatherByCoordsPlainObject, CoordinatesPlainObject, WeatherByCoordsError>
}

extension WeatherByCoordsState {
    
    // MARK: - Initializer
    
    public init() {
        weather = WeatherState(
            timestamp: Date(timeIntervalSince1970: 0),
            temperature: 0,
            pressure: 0,
            humidity: 0,
            windSpeed: 0
        )
        
        /// Set deafult coordinates to Inashiki city in Japan
        reloadableWeatherByCoords = ParameterReloadableState(
            id: CoordinatesPlainObject(lat: 35.95633, lon: 140.32356),
            autoReloadingMode: .none,
            alertMode: .never
        )
    }
}
