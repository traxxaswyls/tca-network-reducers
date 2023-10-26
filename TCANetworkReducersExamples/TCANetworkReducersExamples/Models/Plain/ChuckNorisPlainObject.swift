//
//  ChuckNorisPlainObject.swift
//  TCANetworkReducersExamples
//
//  Created by Gleb Kovalenko on 24.07.2023.
//

import SDAO

// MARK: - ChuckNorisPlainObject

public struct ChuckNorisPlainObject: Codable, Equatable, Plain {
    
    // MARK: - Plain
    
    public var uniqueId: UniqueID {
        UniqueID(rawValue: id)
    }
    
    // MARK: - Properties
    
    /// Joke id
    public let id: String
    
    /// Joke text
    public let value: String
    
    // MARK: - Initializer
    
    public init(
        id: String,
        value: String
    ) {
        self.id = id
        self.value = value
    }
}
