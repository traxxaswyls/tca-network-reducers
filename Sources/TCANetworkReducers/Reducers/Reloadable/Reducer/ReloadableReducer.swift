//
//  ReloadableReducer.swift
//  Ruvpro
//
//  Created by TraxxasWyls on 01/07/2022.
//  Copyright © 2022 Incetro Inc. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Combine

// MARK: - Relodable

public struct RelodableReducer<Data: Equatable & Codable, ErrorType: Error & Equatable>: Reducer {
    
    // MARK: - Properties
    
    /// Main queue scheduler instance
    @Dependency(\.mainQueueScheduler) var mainQueue: AnySchedulerOf<DispatchQueue>
    
    /// Closure for loading target resource
    public let obtain: () -> AnyPublisher<Data, ErrorType>
    
    /// Closure for cache obtating
    public let cache: (() -> AnyPublisher<Data?, ErrorType>)?
    
    // MARK: - Initializers
    
    public init(
        obtain: @escaping () -> AnyPublisher<Data, ErrorType>,
        cache: (() -> AnyPublisher<Data?, ErrorType>)? = nil
    ) {
        self.obtain = obtain
        self.cache = cache
    }
    
    // MARK: - Reducer
    
    public func reduce(
       into state: inout ReloadableState<Data, ErrorType>, action: ReloadableAction<Data, ErrorType>
    ) -> Effect<ReloadableAction<Data, ErrorType>> {
        switch action {
        case .load:
            state.status = .loading
            var actions: [Effect<ReloadableAction<Data, ErrorType>>] = []
            if let cache = cache {
                actions.append(cache()
                    .compactMap { $0 }
                    .catchToEffect(ReloadableAction<Data, ErrorType>.cacheResponse)
                )
            }
            actions.append(.send(.loadingInProgress(true)))
            actions.append(
                obtain()
                    .catchToEffect(ReloadableAction<Data, ErrorType>.response)
            )
            return .merge(actions)
        case .reload:
            state.status = .reloading
            return .merge(
                .send(.loadingInProgress(true)),
                obtain()
                    .catchToEffect(ReloadableAction<Data, ErrorType>.response)
            )
        case .cacheResponse(.success(let data)):
            if state.status == .loading {
                state.data = data
            }
        case .alertDismissed:
            state.alert = nil
        case .response(.success(let data)):
            state.status = .loaded
            state.data = data
            return .send(.loadingInProgress(false))
        case .response(.failure(let error)):
            switch state.alertMode {
            case .onFailure(shoudDisplayOnReload: true),
                 .onFailure(shoudDisplayOnReload: false) where state.status != .reloading:
                state.alert = .init(
                    title: TextState(error.localizedDescription),
                    dismissButton: .default(TextState("Ok"))
                )
            default:
                state.alert = nil
            }
            switch state.autoReloadingMode {
            case .none:
                state.status = .failure
            case .immediate:
                return .send(.reload)
            case .defered(interval: let interval, attempts: let attempts):
                state.reloadingAttemptsCount += 1
                guard state.reloadingAttemptsCount < attempts else {
                    state.status = .failure
                    return .none
                }
                return .send(.reload)
                    .deferred(
                        for: DispatchQueue.SchedulerTimeType.Stride(floatLiteral: interval),
                        scheduler: mainQueue
                    )
            }
        default:
            return .none
        }
        return .none
    }
}
