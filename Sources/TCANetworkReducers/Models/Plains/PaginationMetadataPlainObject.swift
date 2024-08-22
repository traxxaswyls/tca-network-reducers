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

    public let _nextCursor: String?
    private var _hasMore: Bool?
    
    /// True if pagination has more objects
    public var hasMore: Bool {
        if let _hasMore {
            return _hasMore
        } else {
            guard perPage > 0 else { return false }
            let totalPages = ceil(Double(totalCount) / Double(perPage))
            return currentPage < Int(totalPages)
        }
    }

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
        self._nextCursor = nil
    }
    
    public init(
        perPage: Int,
        hasMore: Bool,
        _nextCursor: String? = nil
    ) {
        self.pageCount = -1
        self.totalCount = -1
        self.currentPage = -1
        self.perPage = perPage
        self._hasMore = hasMore
        self._nextCursor = _nextCursor
    }
    
    public static func new(pageSize: Int) -> PaginationMetadataPlainObject {
        PaginationMetadataPlainObject(
            totalObjectCount: 0,
            pageCount: 0,
            currentPage: 0,
            perPage: pageSize
        )
    }
}

// MARK: - Mappable

extension PaginationMetadataPlainObject: ImmutableMappable {
    public init(map: Map) throws {
        totalCount = try map.value("totalCount")
        pageCount = try map.value("pageCount")
        currentPage = try map.value("currentPage")
        perPage = try map.value("perPage")
        _nextCursor = nil
        _hasMore = nil
    }
}
