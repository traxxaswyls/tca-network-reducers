//
//  PaginationExampleItemView.swift
//  TCANetworkReducersExamples
//
//  Created by Dmitry Savinov on 28.07.2023.
//

import SwiftUI
import TCA

// MARK: - PaginationExampleItemView

public struct PaginationExampleItemView: View {
    
    // MARK: - Properties
    
    /// The store powering the `PaginationExampleItem` feature
    public let store: StoreOf<PaginationExampleItemReducer>
    
    // MARK: - View
    
    public var body: some View {
        WithViewStore(store) { viewStore in
        }
    }
}

// MARK: - Preview

struct PaginationExampleItemView_Previews: PreviewProvider {
    static var previews: some View {
        PaginationExampleItemView(
            store: Store(
                initialState: PaginationExampleItemState(),
                reducer: PaginationExampleItemReducer()
            )
        )
    }
}
