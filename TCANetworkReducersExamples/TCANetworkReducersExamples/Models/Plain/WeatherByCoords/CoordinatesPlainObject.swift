//
//  CoordinatesPlainObject.swift
//  Models
//
//  Created by Gleb Kovalenko on 30.07.2023.
//

import SDAO

// MARK: - CoordinatesPlainObject

public struct CoordinatesPlainObject: Equatable, Plain {
    
    // MARK: - Plain
    
    public var uniqueId: UniqueID {
        UniqueID(rawValue: "\(lat) \(lon)")
    }
    
    // MARK: - Properties
    
    /// Coordinate latitude
    public let lat: Double
    
    /// Coordinate longitude
    public let lon: Double
    
    // MARK: - Initializer
    
    public init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
}

// MARK: - Codable

extension CoordinatesPlainObject: Codable {
    
    // MARK: - Initializer
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        lat = try container.decode(Double.self, forKey: .lat)
        lon = try container.decode(Double.self, forKey: .lon)
    }
}
