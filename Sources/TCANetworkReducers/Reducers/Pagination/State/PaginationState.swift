//
//  PaginationState.swift
//  TheRun
//
//  Created by TraxxasWyls on 28/07/2022.
//  Copyright © 2022 Incetro Inc. All rights reserved.
//

import ComposableArchitecture
import Foundation

// MARK: - PaginationState

/// `Pagination` module state
///
/// Basically, `PaginationState` is a type that describes the data
/// `Pagination` feature needs to perform its logic and render its UI.
@dynamicMemberLookup
public struct PaginationState<Response: PaginatedResponse>: Equatable {

    // MARK: - InitialPaginationPolicy
    
    public enum InitialPaginationPolicy: Equatable, Codable {
        
        case onAppear
        case onDidLoad
    }

    // MARK: - RequestStatus

    /// RequestStatus for Pagination
    public enum RequestStatus: Equatable {

        /// No pages have been fetched.
        case none

        /// The pagination fetchHandler is in progress.
        case inProgress

        /// All fetch calls have finished and data exists.
        case done

        /// The pagination fetchHandler is failed.
        case failed
    }

    // MARK: - Properties
    
    public var isInitialized = false
    public var initialPaginationPolicy: InitialPaginationPolicy = .onAppear
    public var currentPagination: Response.Metadata

    /// Size of pages.
    public var pageSize: Int

    /// Last page fetched. Start at 0, fetch calls use page+1 and increment after.
    public var page = 0

    /// Total number of results.
    public var total: Int {
        results.count
    }

    /// The requestStatus defines the current state of the pagination.  If .None, no pages have fetched.
    /// If .InProgress, incoming `fetchNextPage()` calls are ignored.
    public var requestStatus: RequestStatus = .none

    /// Boolean indicating all pages have been fetched
    public var reachedLastPage: Bool {
        if requestStatus == .none || requestStatus == .inProgress && total == 0 {
            return false
        }
        return !currentPagination.hasMore
    }

    /// All results in the order they were received.
    public var results: [Response.Element] = []

    public var isNeededAutomaticButtonLoading = true
    public var isNeededAutomaticPaginationOnAppear = true
    
    // MARK: - Initializers
    
    public init(
        pageSize: Int,
        initialPaginationPolicy: InitialPaginationPolicy = .onAppear,
        isNeededAutomaticPaginationOnAppear: Bool = true
    ) {
        self.initialPaginationPolicy = initialPaginationPolicy
        self.pageSize = pageSize
        self.isNeededAutomaticPaginationOnAppear = isNeededAutomaticPaginationOnAppear
        self.currentPagination = .init(perPage: pageSize)
    }

    // MARK: - DynamicMemberLookup

    public subscript<Dependency>(dynamicMember keyPath: KeyPath<[Response.Element], Dependency>) -> Dependency {
        results[keyPath: keyPath]
    }
}
