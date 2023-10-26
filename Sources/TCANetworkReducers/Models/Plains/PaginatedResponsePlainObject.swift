//
//  PaginatedResponsePlainObject.swift
//  TheRun
//
//  Created by incetro on 3/30/21.
//  Copyright © 2021 Incetro Inc. All rights reserved.
//

import Foundation

// MARK: - PaginatedResponsePlainObject

public struct PaginatedResponsePlainObject<Plain: Decodable & Equatable>: Equatable {

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

    // MARK: - Properties

    /// Pagination info object
    public private(set) var pagination: PaginationMetadataPlainObject

    /// Array of paginated entities
    public private(set) var array: [Plain]
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
