//
//  IDPaginationReducer.swift
//  Chibiverse
//
//  Created by Dmitry Savinov on 07.03.2023.
//

import TCA
import Foundation
import Combine

// MARK: - IDPaginationReducer

public struct IDPaginationReducer<Element: Equatable & Codable, ErrorType: Error & Equatable, ID: Equatable & Codable>: ReducerProtocol {
    
    // MARK: - Properties
    
    /// Main queue scheduler instance
    @Dependency(\.mainQueueScheduler) var mainQueue: AnySchedulerOf<DispatchQueue>
    
    /// The fetchHandler is defined by the user, it defines the behaviour for how to fetch a given page.
    public let fetchHandler: (_ id: ID, _ page: Int, _ pageSize: Int) -> AnyPublisher<Paginated<Element>, ErrorType>
    
    // MARK: - Initializers
    
    public init(
        fetchHandler: @escaping (_ id: ID, _ page: Int, _ pageSize: Int) -> AnyPublisher<Paginated<Element>, ErrorType>
    ) {
        self.fetchHandler = fetchHandler
    }
    
    // MARK: - ReducerProtocol
    
    public func reduce(
       into state: inout IDPaginationState<Element, ID>, action: PaginationAction<Element, ErrorType>
    ) -> EffectTask<PaginationAction<Element, ErrorType>> {
        switch action {
        case .reset:
            state.total = 0
            state.page = 0
            state.requestStatus = .none
            state.results = []
        case .paginate where !state.pagination.reachedLastPage:
            state.requestStatus = .inProgress
            return fetchHandler(state.id, state.page + 1, state.pageSize)
                .catchToEffect(PaginationAction<Element, ErrorType>.response)
        case .response(.success(let paginatedElement)):
            state.results.append(contentsOf: paginatedElement.array)
            state.total = paginatedElement.pagination.totalCount
            state.page += 1
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
