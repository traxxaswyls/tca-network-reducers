//
//  WeatherByCoordsServiceImplementation.swift
//  BusinessLayer
//
//  Created by Gleb Kovalenko on 30.07.2023.
//

import Foundation
import HTTPTransport
import SDAO
import ServiceCore
import Codex
import Models
import TCA
import Monreau

// MARK: - WeatherByCoordsServiceImplementation

public final class WeatherByCoordsServiceImplementation: WebService {
    
    // MARK: - Properties
    
    /// `WeatheByCoords` dao instance
    @Dependency(\.weatherByCoordsDAO) var weatherByCoordsDAO
    
    /// Your api key for air visual api (see https://www.iqair.com/)
    private let apiKey: String = "YOUR API KEY"
    
    // MARK: - Initializer
    
    public init() {
        super.init(
            baseURL: URL(string: "https://api.airvisual.com/v2").unsafelyUnwrapped,
            transport: HTTPTransport()
        )
    }
}

// MARK: - WeatherByCoordsService

extension WeatherByCoordsServiceImplementation: WeatherByCoordsService {
    
    public func obtainWeather(coords: CoordinatesPlainObject) -> ServiceCall<WeatherByCoordsPlainObject> {
        createCall {
            let urlParameters: HTTPRequestParameters = self.fillHTTPRequestParameters(
                self.urlParameters,
                with: [
                    "lat": coords.lat,
                    "lon": coords.lon,
                    "key": self.apiKey
                ]
            )
            let request = HTTPRequest(
                httpMethod: .get,
                endpoint: "/nearest_city",
                parameters: [urlParameters],
                base: self.baseRequest
            )
            let result = self.transport.send(request: request)
            switch result {
            case .success(let response):
                do {
                    let json = try response.getJSONDictionary()?["data"]
                    let data = try JSONSerialization.data(withJSONObject: json as Any)
                    let result = try data.decoded() as WeatherByCoordsPlainObject
                    try self.weatherByCoordsDAO.erase(byPrimaryKey: UniqueID(rawValue: "\(coords.lon) \(coords.lat)"))
                    try self.weatherByCoordsDAO.persist(result)
                    return .success(result)
                } catch {
                    return .failure(error)
                }
            case .failure(let error):
                return .failure(error)
            }
        }
    }
    
    public func readWeather(coords: CoordinatesPlainObject) -> ServiceCall<WeatherByCoordsPlainObject?> {
        createCall {
            let weather = try self.weatherByCoordsDAO.read(byPrimaryKey: UniqueID(rawValue: "\(coords.lon) \(coords.lat)"))
            return .success(weather)
        }
    }
}
