//
//  PaginatedResponsePlainObject.swift
//  TheRun
//
//  Created by incetro on 3/30/21.
//  Copyright © 2021 Incetro Inc. All rights reserved.
//

import Foundation

// MARK: - PaginatedResponsePlainObject

public struct PaginatedResponsePlainObject<Plain: Codable & Equatable> {
    
    // MARK: - CodingKeys

    struct CodingKeys: CodingKey {

        var stringValue: String
        var intValue: Int?

        init(stringValue: String) {
            self.stringValue = stringValue
        }

        init?(intValue: Int) {
            nil
        }
    }
    
    // MARK: - Initializers
    
    public init(
        pagination: PaginationMetadataPlainObject,
        array: [Plain]
    ) {
        self.pagination = pagination
        self.array = array
    }

    // MARK: - Properties

    /// Pagination info object
    public private(set) var pagination: PaginationMetadataPlainObject

    /// Array of paginated entities
    public private(set) var array: [Plain]
}

// MARK: - PaginatedResponse

extension PaginatedResponsePlainObject: PaginatedResponse {
    
    public typealias Element = Plain
    
    public var results: [Plain] {
        array
    }
}

// MARK: - Decodable

extension PaginatedResponsePlainObject: Decodable {

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let arr = container.allKeys.compactMap { try? container.decode([Plain].self, forKey: $0) }
        array = arr.first ?? []
        pagination = try container.decode(PaginationMetadataPlainObject.self, forKey: .init(stringValue: "meta"))
    }
}
