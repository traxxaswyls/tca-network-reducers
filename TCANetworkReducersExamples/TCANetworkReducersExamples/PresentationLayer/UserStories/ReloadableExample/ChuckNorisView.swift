//
//  ChuckNorisView.swift
//  TCANetworkReducersExamples
//
//  Created by Gleb Kovalenko on 24.07.2023.
//

import SwiftUI
import TCA
import BusinessLayer
import PresentationLayer
import TCANetworkReducers

// MARK: - ChuckNorisView

public struct ChuckNorisView: View {
    
    // MARK: - Properties
    
    /// The store powering the `ChuckNoris` feature
    public let store: StoreOf<ChuckNorisReducer>
    
    // MARK: - Initializer
    
    public init(store: StoreOf<ChuckNorisReducer>) {
        self.store = store
    }
    
    // MARK: - View
    
    public var body: some View {
        WithViewStore(store) { viewStore in
            ReloadableView(
                store: store.scope(
                    state: \.reloadableChuckNoris,
                    action: ChuckNorisAction.reloadableChuckNoris
                ),
                loader: {
                    ActivityIndicator(color: .white)
                        .padding(16)
                        .background(.gray)
                        .cornerRadius(8)
                }
            ) {
                Form {
                    Section(header: Text(Constants.summary).font(.system(size: 17))) {
                        if let message = viewStore.chuckNorisResponse.message {
                            Text(message)
                                .font(.system(size: 17, weight: .bold))
                        }
                        Text(viewStore.jokeText)
                        Button {
                            viewStore.send(.getRandomFactButtonTapped)
                        } label: {
                            Text("Get new joke")
                        }
                        .disabled(!viewStore.isGetFactButtonActive)
                    }
                    .textCase(nil)
                }
                .navigationTitle("Reloadable")
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

// MARK: - Constants

extension ChuckNorisView {
    
    enum Constants {
        
        static let summary = """
        This screen shows the simplest example of using a ReloadableReducer
        
        If the request has not yet arrived, the reduser tries to take data from the database (if exist).
        As soon as the response from the network has arrived, the result is shown on the screen
        
        """
    }
}
