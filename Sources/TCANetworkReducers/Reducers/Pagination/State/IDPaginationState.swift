//
//  IDPaginationState.swift
//  TheRun
//
//  Created by Dmitry Savinov on 28.07.2022.
//  Copyright © 2022 Incetro Inc. All rights reserved.
//

import Foundation

// MARK: - IDPaginationState

/// `Pagination` module state
///
/// Basically, `PaginationState` is a type that describes the data
/// `Pagination` feature needs to perform its logic and render its UI.
@dynamicMemberLookup
public struct IDPaginationState<Element, Metadata: PaginationMetadata, ID>: Equatable where Element: Equatable, ID: Equatable {

    // MARK: - Properties

    /// Identifier for loading
    public var id: ID

    /// Reloadable composition instance
    public var pagination: PaginationState<Element, Metadata>

    // MARK: - Initializers

    public init(
        id: ID,
        pageSize: Int,
        initialPaginationPolicy: PaginationState<Element, Metadata>.InitialPaginationPolicy = .onAppear,
        isNeededAutomaticPaginationOnAppear: Bool = true
    ) {
        self.id = id
        self.pagination = .init(
            pageSize: pageSize,
            initialPaginationPolicy: initialPaginationPolicy,
            isNeededAutomaticPaginationOnAppear: isNeededAutomaticPaginationOnAppear
        )
    }

    // MARK: - DynamicMemberLookup

    public subscript<Dependency>(dynamicMember keyPath: WritableKeyPath<PaginationState<Element, Metadata>, Dependency>) -> Dependency {
        get { pagination[keyPath: keyPath] }
        set { pagination[keyPath: keyPath] = newValue }
    }
}
