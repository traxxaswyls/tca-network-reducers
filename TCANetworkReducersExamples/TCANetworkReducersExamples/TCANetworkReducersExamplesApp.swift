//
//  TCANetworkReducersExamplesApp.swift
//  TCANetworkReducersExamples
//
//  Created by Gleb Kovalenko on 26.07.2023.
//

import SwiftUI
import TCA
import Main

@main
struct TCANetworkReducersExamplesApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainView(
                    store: Store(
                        initialState: MainState(),
                        reducer: MainReducer()
                    )
                )
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

// MARK: - Preview

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainView(
                store: Store(
                    initialState: MainState(),
                    reducer: MainReducer()
                )
            )
        }
    }
}
