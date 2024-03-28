//
//  PaginatedResponsePlainObject.swift
//  TheRun
//
//  Created by incetro on 3/30/21.
//  Copyright © 2021 Incetro Inc. All rights reserved.
//

import Foundation
import ObjectMapper

// MARK: - PaginatedResponsePlainObject

public struct PaginatedResponsePlainObject<Plain: Equatable>: Equatable, DefaultPaginatedResponse {

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
    public let pagination: PaginationMetadataPlainObject

    /// Array of paginated entities
    public let array: [Plain]
}

// MARK: - Decodable

extension PaginatedResponsePlainObject: Decodable where Plain: Decodable {

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let arr = container.allKeys.compactMap { try? container.decode([Plain].self, forKey: $0) }
        array = arr.first ?? []
        pagination = try container.decode(PaginationMetadataPlainObject.self, forKey: .init(stringValue: "meta"))
    }
}

// MARK: - Mappable

extension PaginatedResponsePlainObject: BaseMappable where Plain: BaseMappable {
    public mutating func mapping(map: Map) {
        array >>> map["array"]
        pagination >>> map["meta"]
    }
}

extension PaginatedResponsePlainObject: ImmutableMappable where Plain: ImmutableMappable {
    public init(map: Map) throws {
        array = try map.value("array")
        pagination = try map.value("meta")
    }
}
