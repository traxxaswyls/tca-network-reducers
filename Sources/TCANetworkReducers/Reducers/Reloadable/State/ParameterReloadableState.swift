//
//  ParameterReloadableState.swift
//  Ruvpro
//
//  Created by incetro on 7/17/22.
//

import TCA
import Foundation

// MARK: - IDReloadableState

public typealias IDReloadableState<Data: Equatable & Codable, ID: Equatable & Codable, ErrorType: Error & Equatable> = ParameterReloadableState<Data, ID, ErrorType>

// MARK: - ParameterReloadableState

/// `Reloadable` module state
///
/// Basically, `ReloadableState` is a type that describes the data
/// `Reloadable` feature needs to perform its logic and render its UI.
@dynamicMemberLookup
public struct ParameterReloadableState<Data: Equatable & Codable, Parameter: Equatable & Codable, ErrorType: Error & Equatable>: Equatable {

    // MARK: - Properties

    /// Identifier for loading
    public var id: Parameter

    /// Reloadable composition instance
    public var reloadable = ReloadableState<Data, ErrorType>()
    
    // MARK: - Initializers
    
    public init(
        id: Parameter,
        status: ReloadableState<Data, ErrorType>.Status = .initial,
        data: Data? = nil,
        autoReloadingMode: ReloadableState<Data, ErrorType>.AutoReloadingType = .defered(),
        reloadingAttemptsCount: Int = 0,
        alertMode: ReloadableState<Data, ErrorType>.AlertMode = .onFailure(shoudDisplayOnReload: true),
        shouldDisplayLoader: Bool = true
    ) {
        self.id = id
        self.reloadable = ReloadableState<Data, ErrorType>()
        self.reloadable.status = status
        self.reloadable.data = data
        self.reloadable.autoReloadingMode = autoReloadingMode
        self.reloadable.reloadingAttemptsCount = reloadingAttemptsCount
        self.reloadable.alertMode = alertMode
        self.reloadable.shouldDisplayLoader = shouldDisplayLoader
    }

    // MARK: - DynamicMemberLookup

    public subscript<Dependency>(dynamicMember keyPath: WritableKeyPath<ReloadableState<Data, ErrorType>, Dependency>) -> Dependency {
        get { reloadable[keyPath: keyPath] }
        set { reloadable[keyPath: keyPath] = newValue }
    }
}

