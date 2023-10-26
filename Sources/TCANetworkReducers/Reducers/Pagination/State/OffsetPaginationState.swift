//
//  OffsetPaginationState.swift
//  
//
//  Created by Dmitry Savinov on 01.08.2023.
//

import TCA
import Foundation

// MARK: - OffsetPaginationState

/// `Pagination` module state
///
/// Basically, `OffsetPaginationState` is a type that describes the data
/// `Pagination` feature needs to perform its logic and render its UI.
@dynamicMemberLookup
public struct OffsetPaginationState<Element>: Equatable, Codable where Element: Equatable & Codable {
    
    // MARK: - Properties
    
    /// The limit used for this page of results
    public var limit: Int
    
    /// The offset used for this page of results
    public var offset = 0
    
    /// Total number of results.
    public var total = 0
    
    /// Count of the elements on the last request
    public var lastObtainedElmentsCount = 0
    
    /// The requestStatus defines the current state of the pagination.  If .None, no pages have fetched.
    /// If .InProgress, incoming `fetchNextPage()` calls are ignored.
    public var requestStatus: PaginationRequestStatus = .none
    
    /// Boolean indicating all pages have been fetched
    public var reachedLastPage: Bool {
        if requestStatus == .none || requestStatus == .inProgress && total == 0 {
            return false
        } else if total != 0 {
            return results.count >= total
        } else {
            return lastObtainedElmentsCount < limit
        }
    }
    
    /// All results in the order they were received.
    public var results: [Element] = []
    
    /// True if `Load more` button should be displayed
    public var isNeededAutomaticButtonLoading = true
    
    // MARK: - Initializers
    
    public init(limit: Int) {
        self.limit = limit
    }
    
    // MARK: - DynamicMemberLookup
    
    public subscript<Dependency>(dynamicMember keyPath: KeyPath<[Element], Dependency>) -> Dependency {
        results[keyPath: keyPath]
    }
}

