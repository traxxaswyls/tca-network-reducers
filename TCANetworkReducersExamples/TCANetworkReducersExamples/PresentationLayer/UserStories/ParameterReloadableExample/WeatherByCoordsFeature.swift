//
//  WeatherByCoordsReducer.swift
//  ParameterReloadableExample
//
//  Created by Gleb Kovalenko on 30.07.2023.
//

import TCA
import TCANetworkReducers
import BusinessLayer
import CoreLayer
import Models

// MARK: - WeatherByCoordsReducer

public struct WeatherByCoordsReducer: ReducerProtocol {
    
    // MARK: - Properties
    
    /// `WeatherByCoords` service instance
    public let weatherByCoordsService: WeatherByCoordsService
    
    // MARK: - Initializer
    
    public init(weatherByCoordsService: WeatherByCoordsService) {
        self.weatherByCoordsService = weatherByCoordsService
    }
    
    // MARK: - Feature
    
    public var body: some ReducerProtocol<WeatherByCoordsState, WeatherByCoordsAction> {
        Scope(state: \.reloadableWeatherByCoords, action: /WeatherByCoordsAction.reloadableWeatherByCoords) {
            ParameterRelodableReducer { coords in
                weatherByCoordsService
                    .obtainWeather(coords: coords)
                    .publish()
            } cache: { coords in
                weatherByCoordsService
                    .readWeather(coords: coords)
                    .publish()
            }
        }
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .value(.reloadableWeatherByCoords(.load))
            case .reloadableWeatherByCoords(.response(.success(let plain))):
                state.weatherByCoordsResponse = .network
                state.city = plain.city
                state.cityState = plain.state
                state.country = plain.country
                state.weather = WeatherState(plain: plain)
            case .reloadableWeatherByCoords(.cacheResponse(.success(let plain))):
                state.weatherByCoordsResponse = .cache
                state.city = plain.city
                state.cityState = plain.state
                state.country = plain.country
                state.weather = WeatherState(plain: plain)
            case .reloadableWeatherByCoords(.response(.failure(let error))):
                if (error.responseBodyJSONDictionary?["data"] as? [String: String])?["message"] == Constants.cityNotFoundMessage {
                    state.alert = AlertState(title: "City not found")
                } else {
                    state.alert = AlertState(title: error.localizedDescription)
                }
            case .latitudeChanged(let stringValue):
                state.enteredLatitude = stringValue
            case .longitudeChanged(let stringValue):
                state.enteredLongitude = stringValue
            case .getWeatherButtonTapped:
                if let doubleLat = Double(state.enteredLatitude),
                   let doubleLong = Double(state.enteredLongitude) {
                    state.reloadableWeatherByCoords.id = CoordinatesPlainObject(lat: doubleLat, lon: doubleLong)
                    return .value(.reloadableWeatherByCoords(.load))
                } else {
                    state.alert = AlertState(title: "Enter correct coordinates")
                }
            default:
                break
            }
            return .none
        }
    }
}

extension WeatherByCoordsReducer {
    
    // MARK: - Constants
    
    private enum Constants {
        static var cityNotFoundMessage = "city_not_found"
    }
}
