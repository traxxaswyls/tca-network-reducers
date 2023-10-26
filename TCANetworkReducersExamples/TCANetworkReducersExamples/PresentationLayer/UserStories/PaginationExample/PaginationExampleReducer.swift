//
//  PaginationExampleReducer.swift
//  TCANetworkReducersExamples
//
//  Created by Dmitry Savinov on 28.07.2023.
//

import TCA

// MARK: - PaginationExampleReducer

public struct PaginationExampleReducer: ReducerProtocol {
    
    // MARK: - Initializers
    
    public init() {
    }
    
    // MARK: - Feature
    
    public var body: some ReducerProtocol<PaginationExampleState, PaginationExampleAction> {
        Reduce { state, action in
            switch action {
            default:
                break
            }
            return .none
        }
    }
}
