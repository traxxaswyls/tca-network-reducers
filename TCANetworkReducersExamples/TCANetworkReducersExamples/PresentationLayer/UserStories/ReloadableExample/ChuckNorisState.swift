//
//  ChuckNorisState.swift
//  TCANetworkReducersExamples
//
//  Created by Gleb Kovalenko on 24.07.2023.
//

import TCA
import TCANetworkReducers
import Models

// MARK: - ChuckNorisState

public struct ChuckNorisState: Equatable {
    
    // MARK: - ChuckNorisResponse
    
    public enum ChuckNorisResponse {
        
        // MARK: - Cases
        
        case none
        case network
        case cache
        
        // MARK: - Useful
        
        public var message: String? {
            switch self {
            case .none:
                return nil
            case .network:
                return "This is network response"
            case .cache:
                return "This is cache response"
            }
        }
    }
    
    // MARK: - Properties
    
    /// Joke text instance
    public var jokeText: String
    
    /// Indicates which response is got(just for clarity)
    public var chuckNorisResponse: ChuckNorisResponse
    
    /// Indicates which `GetFact` button active
    public var isGetFactButtonActive: Bool {
        reloadableChuckNoris.status != .loading && reloadableChuckNoris.status != .reloading
    }
    
    // MARK: - Children
    
    /// Alert state value
    public var alert: AlertState<ChuckNorisAction>?
    
    // MARK: - Reloadable
    
    /// Reloadable state instance
    public var reloadableChuckNoris = ReloadableState<ChuckNorisPlainObject, ChuckNorisError>(shouldDisplayLoaderOnReloading: true)
}

// MARK: - Initializer

extension ChuckNorisState {
    
    public init() {
        self.jokeText = ""
        self.chuckNorisResponse = .none
    }
}
