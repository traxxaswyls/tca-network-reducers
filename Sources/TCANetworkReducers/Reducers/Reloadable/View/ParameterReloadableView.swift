//
//  ParameterReloadableView.swift
//  
//
//  Created by Gleb Kovalenko on 13.03.2023.
//

import TCA
import SwiftUI

// MARK: - IDReloadableView

public typealias IDReloadableView<
    Data: Equatable & Codable,
    ID: Equatable & Codable,
    ErrorType: Error & Equatable,
    Content: View,
    Loader: View
> = ParameterReloadableView<Data, ID, ErrorType, Content, Loader>

// MARK: - ParameterReloadableView

/// A visual representation of `Reloadable` module.
/// Here we define the view that displays the feature.
/// It holds onto a `Store<ParameterReloadableState, ReloadableAction>` so that it can observe
/// all changes to the state and re-render, and we can send all user actions
/// to the store so that state changes.
public struct ParameterReloadableView<
    Data: Equatable & Codable,
    Parameter: Equatable & Codable,
    ErrorType: Error & Equatable,
    Content: View,
    Loader: View
>: View {

    // MARK: - Aliases

    /// Favorite module Store alias
    public typealias ParameterReloadableStore = Store<ParameterReloadableState<Data, Parameter, ErrorType>, ReloadableAction<Data, ErrorType>>

    // MARK: - Properties

    /// `Animations` module `Store` instance
    private let store: ParameterReloadableStore

    /// Target content that shoud be inside view
    public var content: Content

    /// Target content that shoud used as loader
    public var loader: Loader

    // MARK: - Initializers

    /// Default initializer
    /// - Parameters:
    ///   - store: FavoriteStore instance
    ///   - content: Target content that shoud be inside view
    ///   - loader: Target content that shoud used as loader
    public init(
        store: ParameterReloadableStore,
        @ViewBuilder loader: @escaping () -> Loader,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.store = store
        self.loader = loader()
        self.content = content()
    }
    
    // MARK: - View

    public var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack(alignment: .center) {
                content
                if viewStore.reloadable.isLoaderDisplayed {
                    loader
                }
            }
            .alert(store.scope(state: \.alert), dismiss: .alertDismissed)
        }
    }
}
