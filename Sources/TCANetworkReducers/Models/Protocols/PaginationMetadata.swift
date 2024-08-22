//
//  PaginationMetadata.swift
//
//
//  Created by Gleb Kovalenko on 22.08.2024.
//

// MARK: - PaginationMetadata

public protocol PaginationMetadata: Equatable, Decodable {
    
    // MARK: - Properties
    
    var hasMore: Bool { get }
    var currentPage: Int { get }
    var perPage: Int { get }
    
    // MARK: - Initializers
    
    init(perPage: Int)
}
