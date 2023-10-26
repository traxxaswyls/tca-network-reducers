//
//  PaginationRequestStatus.swift
//  
//
//  Created by Dmitry Savinov on 01.08.2023.
//

import Foundation

// MARK: - RequestStatus

/// RequestStatus for Pagination
public enum PaginationRequestStatus: Equatable, Codable {
    
    /// No pages have been fetched.
    case none
    
    /// The pagination fetchHandler is in progress.
    case inProgress
    
    /// All fetch calls have finished and data exists.
    case done
    
    /// The pagination fetchHandler is failed.
    case failed
}
