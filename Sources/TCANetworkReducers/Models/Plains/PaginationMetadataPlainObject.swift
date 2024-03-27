//
//  PaginationMetadataPlainObject.swift
//  TheRun
//
//  Created by incetro on 3/23/20.
//  Copyright © 2020 Incetro Inc. All rights reserved.
//

import Foundation

// MARK: - PaginationMetadataPlainObject

public struct PaginationMetadataPlainObject: Equatable, Codable {

    // MARK: - Properties
    
    private var _hasMore: Bool?
    
    /// True if pagination has more objects
    public var hasMore: Bool {
        if let _hasMore {
            return _hasMore
        } else {
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
    }
    
    public init(
        perPage: Int,
        hasMore: Bool
    ) {
        self.pageCount = -1
        self.totalCount = -1
        self.currentPage = -1
        self.perPage = perPage
        self._hasMore = hasMore
    }
}
