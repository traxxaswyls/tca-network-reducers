//
//  PaginationMetadataPlainObject.swift
//  TheRun
//
//  Created by incetro on 3/23/20.
//  Copyright © 2020 Incetro Inc. All rights reserved.
//

import Foundation
import ObjectMapper

// MARK: - PaginationMetadataPlainObject

public struct PaginationMetadataPlainObject: Equatable, Codable {

    // MARK: - Properties

    /// Total object count
    public let totalCount: Int

    /// Total pages count
    public let pageCount: Int

    /// Current pagination page
    public let currentPage: Int

    /// Page size
    public let perPage: Int
}

// MARK: - Initializer

extension PaginationMetadataPlainObject {
    
    public init(
        totalObjectCount: Int,
        pageCount: Int,
        currentPage: Int,
        perPage: Int
    ) {
        self.currentPage = currentPage
        self.pageCount = pageCount
        self.perPage = perPage
        self.totalCount = totalObjectCount
    }
}

// MARK: - Mappable

extension PaginationMetadataPlainObject: ImmutableMappable {
    public init(map: Map) throws {
        totalCount = try map.value("totalCount")
        pageCount = try map.value("pageCount")
        currentPage = try map.value("currentPage")
        perPage = try map.value("perPage")
    }
}
