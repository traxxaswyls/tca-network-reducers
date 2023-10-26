//
//  ChuckNorisReducer.swift
//  TCANetworkReducersExamples
//
//  Created by Gleb Kovalenko on 24.07.2023.
//

import TCA
import TCANetworkReducers
import BusinessLayer
import Foundation

// MARK: - ChuckNorisReducer

public struct ChuckNorisReducer: ReducerProtocol {
    
    // MARK: - Properties
    
    /// `ChuckNoris` service instance
    private let chuckNorisService: ChuckNorisService
    
    // MARK: - Initializer
    
    public init(chuckNorisService: ChuckNorisService) {
        self.chuckNorisService = chuckNorisService
    }
    
    // MARK: - Feature
    
    public var body: some ReducerProtocol<ChuckNorisState, ChuckNorisAction> {
        Scope(state: \.reloadableChuckNoris, action: /ChuckNorisAction.reloadableChuckNoris) {
            RelodableReducer {
                chuckNorisService
                    .obtainRandomJoke()
                    .publish()
            } cache: {
                chuckNorisService
                    .readRandomJoke()
                    .publish()
            }
        }
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .value(.reloadableChuckNoris(.load))
            case .getRandomFactButtonTapped:
                return .value(.reloadableChuckNoris(.reload))
            case .reloadableChuckNoris(.response(.success(let plain))):
                state.chuckNorisResponse = .network
                state.jokeText = plain.value
            case .reloadableChuckNoris(.cacheResponse(.success(let plain))):
                state.chuckNorisResponse = .cache
                state.jokeText = plain.value
            default:
                break
            }
            return .none
        }
    }
}
