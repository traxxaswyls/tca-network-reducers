//
//  DefaultPaginatedResponse.swift
//  
//
//  Created by Dmitry Savinov on 01.08.2023.
//

import Foundation

// MARK: - DefaultPaginatedResponse

public protocol DefaultPaginatedResponse: PaginatedResponse {
    
    // MARK: - Properties
    
    var pagination: PaginationMetadataPlainObject { get }
    var results: [Element] { get }
}
