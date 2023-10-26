//
//  OffsetPaginationMetadataPlainObject.swift
//  
//
//  Created by Dmitry Savinov on 01.08.2023.
//

import Foundation

// MARK: - OffsetPaginationMetadataPlainObject

public struct OffsetPaginationMetadataPlainObject: Equatable, Codable {
    
    // MARK: - Properties
    
    /// The limit used for this page of results
    public var limit: Int
    
    /// The offset used for this page of results
    public var offset = 0
    
    /// Total number of results.
    public var total = 0
    
    // MARK: - Initializers
    
    /// Default initializer
    /// - Parameters:
    ///   - offset: The limit used for this page of results
    ///   - limit: The offset used for this page of results
    ///   - total: Total number of results
    public init(offset: Int, limit: Int, total: Int) {
        self.offset = offset
        self.limit = limit
        self.total = total
    }
}
