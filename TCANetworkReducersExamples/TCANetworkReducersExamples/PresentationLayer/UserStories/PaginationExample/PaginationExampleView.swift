//
//  PaginationExampleView.swift
//  PaginationExample
//
//  Created by Dmitry Savinov on 28.07.2023.
//

import SwiftUI
import TCA

// MARK: - PaginationExampleView

public struct PaginationExampleView: View {
    
    // MARK: - Properties
    
    /// The store powering the `PaginationExample` reducer
    public let store: StoreOf<PaginationExampleReducer>
    
    // MARK: - Initializers
    
    public init(store: StoreOf<PaginationExampleReducer>) {
        self.store = store
    }
    
    // MARK: - View
    
    public var body: some View {
        WithViewStore(store) { viewStore in
        }
    }
}

// MARK: - Preview

struct PaginationExampleView_Previews: PreviewProvider {
    static var previews: some View {
        PaginationExampleView(
            store: Store(
                initialState: PaginationExampleState(),
                reducer: PaginationExampleReducer()
            )
        )
    }
}
