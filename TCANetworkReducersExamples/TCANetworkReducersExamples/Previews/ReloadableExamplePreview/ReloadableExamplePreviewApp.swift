//
//  ReloadableExamplePreviewApp.swift
//  ReloadableExamplePreview
//
//  Created by Gleb Kovalenko on 27.07.2023.
//

import SwiftUI
import TCA
import ReloadableExample
import BusinessLayer

@main
struct ReloadableExamplePreviewApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ChuckNorisView(
                    store: Store(
                        initialState: ChuckNorisState(),
                        reducer: ChuckNorisReducer(
                            chuckNorisService: ChuckNorisServiceImplementation()
                        )
                    )
                )
            }
        }
    }
}

// MARK: - Preview

struct ChuckNorisView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChuckNorisView(
                store: Store(
                    initialState: ChuckNorisState(),
                    reducer: ChuckNorisReducer(
                        chuckNorisService: ChuckNorisServiceImplementation()
                    )
                )
            )
        }
    }
}
