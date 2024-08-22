//
//  PaginationReducer.swift
//  TheRun
//
//  Created by TraxxasWyls on 28/07/2022.
//  Copyright © 2022 Incetro Inc. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Combine

// MARK: - PaginationReducer

public struct PaginationReducer<Response: DefaultPaginatedResponse, ErrorType: Error & Equatable>: Reducer {
    
    // MARK: - Aliases
    
    public typealias PublisherObtain = (_ page: Int, _ pageSize: Int) -> AnyPublisher<Response, ErrorType>
    public typealias AsyncObtain = (_ page: Int, _ pageSize: Int) async throws -> Response
    
    // MARK: - Operation
    
    public enum Operation {
        case publisher(PublisherObtain)
        case run(AsyncObtain)
    }

    // MARK: - Properties
    
    /// Main queue scheduler instance
    @Dependency(\.mainQueueScheduler) var mainQueue: AnySchedulerOf<DispatchQueue>
    
    /// The fetchHandler is defined by the user, it defines the behaviour for how to fetch a given page.
    public let fetchHandler: Operation
    
    // MARK: - Initializers
    
    public init(fetchHandler: @escaping PublisherObtain) {
        self.fetchHandler = .publisher(fetchHandler)
    }
    
    public init(fetchHandler: @escaping AsyncObtain) {
        self.fetchHandler = .run(fetchHandler)
    }
    
    // MARK: - Static

    public static func publisher(fetchHandler: @escaping PublisherObtain) -> Self {
        PaginationReducer(fetchHandler: fetchHandler)
    }
    
    public static func run(fetchHandler: @escaping AsyncObtain) -> Self {
        PaginationReducer(fetchHandler: fetchHandler)
    }
    
    // MARK: - ReducerProtocol
    
    public func reduce(
        into state: inout PaginationState<Response.Element>, action: PaginationAction<Response, ErrorType>
    ) -> Effect<PaginationAction<Response, ErrorType>> {
        switch action {
        case .onAppear:
            if (state.initialPaginationPolicy == .onDidLoad && !state.isInitialized) || state.initialPaginationPolicy == .onAppear {
                return .send(.paginate)
            }
            state.isInitialized = true
        case .reset:
            state.currentPagination = .new(pageSize: state.pageSize)
            state.page = 0
            state.requestStatus = .none
            state.results = []
        case .paginate where !state.reachedLastPage:
            state.requestStatus = .inProgress
            switch fetchHandler {
            case .publisher(let publisherObtain):
                return publisherObtain(state.page + 1, state.pageSize)
                    .catchToEffect(PaginationAction<Response, ErrorType>.response)
            case .run(let asyncObtain):
                return .run { [state = state] send in
                    do {
                        let result = try await asyncObtain(state.page + 1, state.pageSize)
                        await send(.response(.success(result)))
                    } catch let error as ErrorType {
                        await send(.response(.failure(error)))
                    } catch {
                        assertionFailure("Unknown error type `\(type(of: error))`, expected `\(ErrorType.Type.self)`")
                    }
                }
            }
        case .response(.success(let paginatedElement)):
            state.isNeededAutomaticButtonLoading = false
            state.results.append(contentsOf: paginatedElement.array)
            state.page += 1
            state.requestStatus = .done
            if state.results.count >= state.total {
                return .send(.allElementsFetched)
            }
        case .response(.failure):
            state.requestStatus = .failed
        default:
            return .none
        }
        return .none
    }
}
