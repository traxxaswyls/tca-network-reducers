//
//  OffsetPaginatedResponse.swift
//  
//
//  Created by Dmitry Savinov on 01.08.2023.
//

import Foundation

// MARK: - OffsetPaginatedResponse

public protocol OffsetPaginatedResponse: PaginatedResponse {
        
    // MARK: - Properties
    
    var pagination: OffsetPaginationMetadataPlainObject { get }
    var results: [Element] { get }
}
