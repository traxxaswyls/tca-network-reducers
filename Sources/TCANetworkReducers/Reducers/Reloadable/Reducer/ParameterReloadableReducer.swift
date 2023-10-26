//
//  ParameterReloadableReducer.swift
//  Chibiverse
//
//  Created by Dmitry Savinov on 07.03.2023.
//

import TCA
import Foundation
import Combine

// MARK: - IDRelodableReducer

public typealias IDRelodableReducer<Data: Equatable & Codable, ID: Equatable & Codable, ErrorType: Error & Equatable> = ParameterRelodableReducer<Data, ID, ErrorType>

// MARK: - ParameterRelodableReducer

public struct ParameterRelodableReducer<Data: Equatable & Codable, Parameter: Equatable & Codable, ErrorType: Error & Equatable>: ReducerProtocol {
    
    // MARK: - Properties
    
    /// Main queue scheduler instance
    @Dependency(\.mainQueueScheduler) var mainQueue: AnySchedulerOf<DispatchQueue>
    
    /// Closure for loading target resource
    public let obtain: (Parameter) -> AnyPublisher<Data, ErrorType>

    /// Closure for cache obtating
    public let cache: ((Parameter) -> AnyPublisher<Data?, ErrorType>)?
    
    // MARK: - Initializers
    
    public init(
        obtain: @escaping (Parameter) -> AnyPublisher<Data, ErrorType>,
        cache: ((Parameter) -> AnyPublisher<Data?, ErrorType>)? = nil
    ) {
        self.obtain = obtain
        self.cache = cache
    }
    
    // MARK: - ReducerProtocol
    
    public func reduce(
       into state: inout ParameterReloadableState<Data, Parameter, ErrorType>, action: ReloadableAction<Data, ErrorType>
    ) -> EffectTask<ReloadableAction<Data, ErrorType>> {
        switch action {
        case .load:
            state.status = .loading
            var actions: [Effect<ReloadableAction<Data, ErrorType>, Never>] = []
            if let obtainCache = cache {
                actions.append(obtainCache(state.id)
                    .compactMap { $0 }
                    .catchToEffect(ReloadableAction<Data, ErrorType>.cacheResponse)
                )
            }
            actions.append(.value(.loadingInProgress(true)))
            actions.append(
                obtain(state.id)
                    .catchToEffect(ReloadableAction<Data, ErrorType>.response)
            )
            return .merge(actions)
        case .cacheResponse(.success(let data)):
            if state.status == .loading {
                state.data = data
            }
        case .alertDismissed:
            state.alert = nil
        case .reload:
            state.status = .reloading
            return .merge(
                .value(.loadingInProgress(true)),
                obtain(state.id)
                    .catchToEffect(ReloadableAction<Data, ErrorType>.response)
            )
        case .response(.success(let data)):
            state.status = .loaded
            state.data = data
            return .value(.loadingInProgress(false))
        case .response(.failure(let error)):
            switch state.alertMode {
            case .onFailure(shoudDisplayOnReload: true),
                    .onFailure(shoudDisplayOnReload: false) where state.status != .reloading:
                state.alert = .init(
                    title: error.localizedDescription,
                    dismissButton: .default("Ok")
                )
            default:
                state.alert = nil
            }
            switch state.autoReloadingMode {
            case .none:
                state.status = .failure
            case .immediate:
                return .value(.reload)
            case .defered(interval: let interval, attempts: let attempts):
                state.reloadingAttemptsCount += 1
                guard state.reloadingAttemptsCount < attempts else {
                    state.status = .failure
                    return .none
                }
                return .value(.reload)
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
