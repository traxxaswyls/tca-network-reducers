//
//  PaginationView.swift
//  TheRun
//
//  Created by TraxxasWyls on 28/07/2022.
//  Copyright © 2022 Incetro Inc. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

// MARK: - PaginationView

/// A visual representation of `Pagination` module.
/// Here we define the view that displays the feature.
/// It holds onto a `Store<PaginationState, PaginationAction>` so that it can observe
/// all changes to the state and re-render, and we can send all user actions
/// to the store so that state changes.
public struct PaginationView<
    Element: Equatable & Codable,
    ErrorType: Error & Equatable,
    Loader: View
>: View {
    
    // MARK: - Aliases
    
    /// Favorite module Store alias
    public typealias PaginationStore = Store<PaginationState<Element>, PaginationAction<Element, ErrorType>>
    
    // MARK: - Properties
    
    /// `Pagination` module `Store` instance
    private let store: PaginationStore
    
    /// Target content that shoud used as loader
    public var loader: () -> Loader
    
    public let isLoadingButton: Bool
    
    // MARK: - Initializers
    
    /// Default initializer
    /// - Parameters:
    ///   - store: FavoriteStore instance
    ///   - content: Target content that shoud be inside view
    ///   - loader: Target content that shoud used as loader
    public init(
        store: PaginationStore,
        isLoadingButton: Bool = false,
        @ViewBuilder loader: @escaping () -> Loader
    ) {
        self.isLoadingButton = isLoadingButton
        self.store = store
        self.loader = loader
    }
    // MARK: - View
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            if !viewStore.reachedLastPage {
                if isLoadingButton && !viewStore.isNeededAutomaticButtonLoading {
                    Button {
                        viewStore.send(.paginate)
                    } label: {
                        Text("Load more")
                            .font(.system(size: 15, weight: .semibold))
                    }.onAppear {
                        if viewStore.isNeededAutomaticButtonLoading {
                            viewStore.send(.paginate)
                        }
                    }
                } else if viewStore.isNeededAutomaticPaginationOnAppear {
                    loader()
                        .onAppear {
                            viewStore.send(.onAppear)
                        }
                }
            }
        }
    }
}
