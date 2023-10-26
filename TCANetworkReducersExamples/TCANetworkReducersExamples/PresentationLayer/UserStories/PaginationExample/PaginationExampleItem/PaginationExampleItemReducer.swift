//
//  PaginationExampleItemReducer.swift
//  TCANetworkReducersExamples
//
//  Created by Dmitry Savinov on 28.07.2023.
//

import TCA

// MARK: - PaginationExampleItemReducer

public struct PaginationExampleItemReducer: ReducerProtocol {
    
    // MARK: - Feature
    
    public var body: some ReducerProtocol<PaginationExampleItemState, PaginationExampleItemAction> {
        Reduce { state, action in
            switch action {
            default:
                break
            }
            return .none
        }
    }
}
