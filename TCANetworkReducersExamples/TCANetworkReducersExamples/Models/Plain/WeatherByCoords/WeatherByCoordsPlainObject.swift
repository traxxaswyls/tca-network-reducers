//
//  WeatherByCoordsPlainObject.swift
//  Models
//
//  Created by Gleb Kovalenko on 30.07.2023.
//

import SDAO

// MARK: - WeatherByCoordsPlainObject

public struct WeatherByCoordsPlainObject: Equatable, Plain {
    
    // MARK: - Plain
    
    public var uniqueId: UniqueID {
        UniqueID(rawValue: "\(location.lon) \(location.lat)")
    }
    
    // MARK: - Properties
    
    /// Found city
    public let city: String
    
    /// Found state
    public let state: String
    
    /// Found country
    public let country: String
    
    /// Found weather
    public let weather: WeatherPlainObject
    
    /// Found location
    public let location: CoordinatesPlainObject
    
    // MARK: - Initializer
    
    public init(
        city: String,
        state: String,
        country: String,
        weather: WeatherPlainObject,
        location: CoordinatesPlainObject
    ) {
        self.city = city
        self.state = state
        self.country = country
        self.weather = weather
        self.location = location
    }
}

// MARK: - Codable

extension WeatherByCoordsPlainObject: Codable {
    
    // MARK: - CodingKeys
    
    public enum CodingKeys: String, CodingKey {
        
        // MARK: - Cases
        
        case city
        case state
        case country
        case location
        case weather = "current"
    }
    
    public enum NestedCodingKeys: String, CodingKey {
        
        // MARK: - Cases
        
        case coordinates
        case weather
    }
    
    // MARK: - Initializer
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        city = try container.decode(String.self, forKey: .city)
        state = try container.decode(String.self, forKey: .state)
        country = try container.decode(String.self, forKey: .country)
        
        // Extract "weather" field from the "current" dictionary
        let weathernNestedContainer = try container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .weather)
        weather = try weathernNestedContainer.decode(WeatherPlainObject.self, forKey: .weather)
        
        // Extract "coordinates" field from the "location" dictionary
        let locationNestedContainer = try container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .location)
        let coordinates = try locationNestedContainer.decode([Double].self, forKey: .coordinates)
        location = CoordinatesPlainObject(lat: coordinates[1], lon: coordinates[0])
    }
}
