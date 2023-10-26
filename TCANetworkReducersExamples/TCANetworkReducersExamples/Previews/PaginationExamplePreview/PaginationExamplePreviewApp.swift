//
//  PaginationExamplePreviewApp.swift
//  PaginationExamplePreview
//
//  Created by Dmitry Savinov on 28.07.2023.
//

import SwiftUI
import PaginationExample
import TCA

@main
struct PaginationExamplePreviewApp: App {
    var body: some Scene {
        WindowGroup {
            PaginationExampleView(
                store: Store(
                    initialState: PaginationExampleState(),
                    reducer: PaginationExampleReducer()
                )
            )
        }
    }
}


struct PaginationExampleView_Preview: PreviewProvider {
    
    static var previews: some View {
        PaginationExampleView(
            store: Store(
                initialState: PaginationExampleState(),
                reducer: PaginationExampleReducer()
            )
        )
    }
}
