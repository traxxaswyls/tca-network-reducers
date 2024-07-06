//
//  IDReloadableReducer.swift
//  Chibiverse
//
//  Created by Dmitry Savinov on 07.03.2023.
//

import ComposableArchitecture
import Foundation
import Combine

// MARK: - Relodable

public struct IDRelodableReducer<Data: Equatable & Codable, ID: Equatable & Codable, ErrorType: Error & Equatable>: Reducer {
    
    // MARK: - Aliases
    
    public typealias PublisherObtain<D> = (ID) -> AnyPublisher<D, ErrorType>
    public typealias AsyncObtain<D> = (ID) async throws -> D
    
    // MARK: - Operation
    
    public enum Operation<D> {
        case publisher(PublisherObtain<D>)
        case run(AsyncObtain<D>)
    }
    
    // MARK: - Properties
    
    /// Main queue scheduler instance
    @Dependency(\.mainQueueScheduler) var mainQueue: AnySchedulerOf<DispatchQueue>
    
    /// Closure for loading target resource
    public let obtain: Operation<Data>
    
    /// Closure for cache obtating
    public var cache: Operation<Data?>?
    
    // MARK: - Initializers
    
    public init(
        obtain: @escaping PublisherObtain<Data>,
        cache: PublisherObtain<Data?>? = nil
    ) {
        self.obtain = .publisher(obtain)
        self.cache = cache.map { .publisher($0) }
    }
    
    public init(
        obtain: @escaping AsyncObtain<Data>,
        cache: AsyncObtain<Data?>? = nil
    ) {
        self.obtain = .run(obtain)
        self.cache = cache.map { .run($0) }
    }
    
    // MARK: - Static
    
    public static func publisher(
        obtain: @escaping PublisherObtain<Data>,
        cache: PublisherObtain<Data?>? = nil
    ) -> Self {
        IDRelodableReducer(
            obtain: obtain,
            cache: cache
        )
    }

    public static func run(
        obtain: @escaping AsyncObtain<Data>,
        cache: AsyncObtain<Data?>? = nil
    ) -> Self {
        IDRelodableReducer(
            obtain: obtain,
            cache: cache
        )
    }
    
    // MARK: - Reducer
    
    public func reduce(
       into state: inout IDReloadableState<Data, ID, ErrorType>, action: ReloadableAction<Data, ErrorType>
    ) -> Effect<ReloadableAction<Data, ErrorType>> {
        switch action {
        case .load:
            state.status = .loading
            var actions: [Effect<ReloadableAction<Data, ErrorType>>] = []
            actions.append(convertedCache(id: state.id))
            actions.append(.send(.loadingInProgress(true)))
            actions.append(convertedObtain(id: state.id))
            return .merge(actions)
        case .cacheResponse(.success(let data)):
            state.data = data
        case .alertDismissed:
            state.alert = nil
        case .reload:
            state.status = .reloading
            return .merge(
                .send(.loadingInProgress(true)),
                convertedObtain(id: state.id)
            )
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
    
    private func convertedObtain(id: ID) -> Effect<ReloadableAction<Data, ErrorType>> {
        switch obtain {
        case .publisher(let obtain):
            return obtain(id).catchToEffect(ReloadableAction<Data, ErrorType>.response)
        case .run(let act):
            return .run { send in
                do {
                    let data = try await act(id)
                    await send(.response(.success(data)))
                } catch let error as ErrorType {
                    await send(.response(.failure(error)))
                } catch {
                    assertionFailure("Unknown error type `\(type(of: error))`, expected `\(ErrorType.Type.self)`")
                }
            }
        }
    }
    
    private func convertedCache(id: ID) -> Effect<ReloadableAction<Data, ErrorType>> {
        switch cache {
        case .publisher(let obtain):
            return obtain(id).catchToEffect(ReloadableAction<Data, ErrorType>.cacheResponse)
        case .run(let act):
            return .run { send in
                do {
                    let data = try await act(id)
                    await send(.cacheResponse(.success(data)))
                } catch let error as ErrorType {
                    await send(.cacheResponse(.failure(error)))
                } catch {
                    assertionFailure("Unknown error type `\(type(of: error))`, expected `\(ErrorType.Type.self)`")
                }
            }
        default:
            return .none
        }
    }
}
