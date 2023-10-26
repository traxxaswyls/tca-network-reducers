//
//  MainReducer.swift
//  TCANetworkReducersExamples
//
//  Created by Gleb Kovalenko on 26.07.2023.
//

import TCA
import ReloadableExample
import BusinessLayer

// MARK: - MainReducer

public struct MainReducer: ReducerProtocol {
    
    // MARK: - Initializer
    
    public init() {}
    
    // MARK: - Feature
    
    public var body: some ReducerProtocol<MainState, MainAction> {
        Scope(state: \.reloadableExample, action: /MainAction.reloadableExample) {
            ChuckNorisReducer(
                chuckNorisService: ChuckNorisServiceImplementation()
            )
        }
        Reduce { state, action in
            switch action {
            default:
                break
            }
            return .none
        }
    }
}
