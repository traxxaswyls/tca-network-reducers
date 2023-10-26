//
//  ChuckNorisAction.swift
//  TCANetworkReducersExamples
//
//  Created by Gleb Kovalenko on 24.07.2023.
//

import TCANetworkReducers
import Models

// MARK: - ChuckNorisAction

public enum ChuckNorisAction: Equatable {
    
    // MARK: - Cases
    
    /// General action that calls when view appears
    case onAppear
    
    /// An action that calls when user taps on the `GetRandomFact` button
    case getRandomFactButtonTapped
    
    /// An action that calls when user taps on the `dismiss` button on the alert
    case alertDismissed
    
    // MARK: - Reloadable
    
    /// Reloadable action instance
    case reloadableChuckNoris(ReloadableAction<ChuckNorisPlainObject, ChuckNorisError>)
}
