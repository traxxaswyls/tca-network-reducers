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

    /// Total object count
    public let totalCount: Int

    /// Total pages count
    public let pageCount: Int

    /// Current pagination page
    public let currentPage: Int

    /// Page size
    public let perPage: Int
    
    // MARK: - Initializers
    
    public init(totalCount: Int, pageCount: Int, currentPage: Int, perPage: Int) {
        self.totalCount = totalCount
        self.pageCount = pageCount
        self.currentPage = currentPage
        self.perPage = perPage
    }
}
