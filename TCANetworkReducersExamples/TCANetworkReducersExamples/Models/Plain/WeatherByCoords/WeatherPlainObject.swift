//
//  WeatherPlainObject.swift
//  Models
//
//  Created by Gleb Kovalenko on 30.07.2023.
//

import Foundation
import CoreLayer
import SDAO

// MARK: - WeatherPlainObject

public struct WeatherPlainObject: Equatable, Plain {
    
    // MARK: - Plain
    
    public var uniqueId: UniqueID {
        UniqueID(rawValue: "\(timestamp.timeIntervalSince1970) \(pressure) \(temperature) \(humidity) \(windSpeed)")
    }
    
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

// MARK: - Codable

extension WeatherPlainObject: Codable {
    
    // MARK: - CodingKeys
    
    public enum CodingKeys: String, CodingKey {
        
        // MARK: - Cases
        
        case timestamp = "ts"
        case temperature = "tp"
        case pressure = "pr"
        case humidity = "hu"
        case windSpeed = "ws"
    }
    
    // MARK: - Initializer
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let timestampString = try container.decode(String.self, forKey: .timestamp)
        if let timestamp = DateFormatter.iso8601.date(from: timestampString) {
            self.timestamp = timestamp
        } else {
            throw DecodingError.dataCorruptedError(forKey: .timestamp, in: container, debugDescription: "Invalid date format")
        }
        temperature = try container.decode(Int.self, forKey: .temperature)
        pressure = try container.decode(Int.self, forKey: .pressure)
        humidity = try container.decode(Int.self, forKey: .humidity)
        windSpeed = try container.decode(Double.self, forKey: .windSpeed)
    }
}
