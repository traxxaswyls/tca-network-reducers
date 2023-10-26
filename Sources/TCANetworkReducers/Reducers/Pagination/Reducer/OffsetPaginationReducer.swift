//
//  OffsetPaginationReducer.swift
//  
//
//  Created by Dmitry Savinov on 01.08.2023.
//

import TCA
import Foundation
import Combine

// MARK: - OffsetPaginationReducer

public struct OffsetPaginationReducer<Response: OffsetPaginatedResponse, ErrorType: Error & Equatable>: ReducerProtocol {
    
    // MARK: - Properties
    
    /// Main queue scheduler instance
    @Dependency(\.mainQueueScheduler) var mainQueue: AnySchedulerOf<DispatchQueue>
    
    /// The fetchHandler is defined by the user, it defines the behaviour for how to fetch a given page.
    public var fetchHandler: (_ offset: Int, _ limit: Int) -> AnyPublisher<Response, ErrorType>
    
    // MARK: - Initializers
    
    public init(
        fetchHandler: @escaping (_ offset: Int, _ limit: Int) -> AnyPublisher<Response, ErrorType>
    ) {
        self.fetchHandler = fetchHandler
    }
    
    // MARK: - ReducerProtocol
    
    public func reduce(
        into state: inout OffsetPaginationState<Response.Element>, action: PaginationAction<Response, ErrorType>
    ) -> EffectTask<PaginationAction<Response, ErrorType>> {
        switch action {
        case .reset:
            state.total = 0
            state.offset = 0
            state.requestStatus = .none
            state.results = []
        case .paginate where !state.reachedLastPage && state.requestStatus != .inProgress:
            state.requestStatus = .inProgress
            return fetchHandler(state.offset, state.limit)
                .catchToEffect(PaginationAction<Response, ErrorType>.response)
        case .response(.success(let paginatedElement)):
            state.isNeededAutomaticButtonLoading = false
            state.results.append(contentsOf: paginatedElement.results)
            state.total = paginatedElement.pagination.total
            state.offset += paginatedElement.results.count
            state.requestStatus = .done
            if state.results.count >= state.total {
                return .value(.allElementsFetched)
            }
        case .response(.failure):
            state.requestStatus = .failed
        default:
            return .none
        }
        return .none
    }
}
