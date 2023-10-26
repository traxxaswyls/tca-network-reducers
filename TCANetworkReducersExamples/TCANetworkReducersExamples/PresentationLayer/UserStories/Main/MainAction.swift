//
//  MainAction.swift
//  TCANetworkReducersExamples
//
//  Created by Gleb Kovalenko on 26.07.2023.
//

import ReloadableExample

// MARK: - MainAction

public enum MainAction: Equatable {
    
    // MARK: - Children
    
    /// Child action for `ReloadableExample` module.
    ///
    /// It's necessary as we use `Scope` reducer in current module's reducer.
    /// In short, the `reloadableExample` case means that every action in `ReloadableExample` module
    /// will be sent to current module through it
    case reloadableExample(ChuckNorisAction)
}
