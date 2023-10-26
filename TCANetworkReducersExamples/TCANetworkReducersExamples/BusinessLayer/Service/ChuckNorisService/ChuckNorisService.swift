//
//  ChuckNorisService.swift
//  TCANetworkReducersExamples
//
//  Created by Gleb Kovalenko on 24.07.2023.
//

import ServiceCore
import Models

// MARK: - ChuckNorisServiceAction

public enum ChuckNorisServiceAction: Equatable {
    
    // MARK: - Cases
    
    case randomFactObtained(ChuckNorisPlainObject)
}

// MARK: - ChuckNorisService

public protocol ChuckNorisService {
    
    /// Obtain random fact
    /// - Returns: random cat fact plain object
    func obtainRandomJoke() -> ServiceCall<ChuckNorisPlainObject>
    
    /// Read random fact from local db
    /// - Returns: random cat fact plain object if exist
    func readRandomJoke() -> ServiceCall<ChuckNorisPlainObject?>
}
