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
    
    // MARK: - Aliases
    
    public typealias PublisherObtain = () -> AnyPublisher<Data, ErrorType>
    public typealias AsyncObtain = () async throws -> Data
    
    // MARK: - Operation
    
    public enum Operation {
        case publisher(PublisherObtain)
        case run(AsyncObtain)
    }
    
    // MARK: - Properties
    
    /// Main queue scheduler instance
    @Dependency(\.mainQueueScheduler) var mainQueue: AnySchedulerOf<DispatchQueue>
    
    /// Closure for loading target resource
    public let obtain: Operation
    
    /// Closure for cache obtating
    public let cache: Operation?
    
    // MARK: - Initializers
    
    public init(
        obtain: @escaping PublisherObtain,
        cache: PublisherObtain? = nil
    ) {
        self.obtain = .publisher(obtain)
        self.cache = cache.map { .publisher($0) }
    }
    
    public init(
        obtain: @escaping AsyncObtain,
        cache: AsyncObtain? = nil
    ) {
        self.obtain = .run(obtain)
        self.cache = cache.map { .run($0) }
    }
    
    // MARK: - ReducerProtocol
    
    public func reduce(
        into state: inout ReloadableState<Data, ErrorType>, action: ReloadableAction<Data, ErrorType>
    ) -> Effect<ReloadableAction<Data, ErrorType>> {
        switch action {
        case .load:
            state.status = .loading
            var actions: [Effect<ReloadableAction<Data, ErrorType>>] = []
            actions.append(convertedCache())
            actions.append(.send(.loadingInProgress(true)))
            actions.append(convertedObtain())
            return .merge(actions)
        case .reload:
            state.status = .reloading
            return .merge(
                .send(.loadingInProgress(true)),
                convertedObtain()
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
                state.alert = AlertState(
                    title: TextState("Error"),
                    message: TextState(error.localizedDescription),
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
    
    private func convertedObtain() -> Effect<ReloadableAction<Data, ErrorType>> {
        switch obtain {
        case .publisher(let obtain):
            return obtain().catchToEffect(ReloadableAction<Data, ErrorType>.response)
        case .run(let act):
            return .run { send in
                do {
                    let data = try await act()
                    await send(.response(.success(data)))
                } catch let error as ErrorType {
                    await send(.response(.failure(error)))
                } catch {
                    assertionFailure("Unknown error type `\(type(of: error))`, expected `\(ErrorType.Type.self)`")
                }
            }
        }
    }
    
    private func convertedCache() -> Effect<ReloadableAction<Data, ErrorType>> {
        switch cache {
        case .publisher(let obtain):
            return obtain().catchToEffect(ReloadableAction<Data, ErrorType>.response)
        case .run(let act):
            return .run { send in
                do {
                    let data = try await act()
                    await send(.response(.success(data)))
                } catch let error as ErrorType {
                    await send(.response(.failure(error)))
                } catch {
                    assertionFailure("Unknown error type `\(type(of: error))`, expected `\(ErrorType.Type.self)`")
                }
            }
        default:
            return .none
        }
    }
}
