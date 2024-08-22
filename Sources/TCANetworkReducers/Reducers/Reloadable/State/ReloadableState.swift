//
//  ReloadableState.swift
//  Ruvpro
//
//  Created by TraxxasWyls on 01/07/2022.
//  Copyright © 2022 Incetro Inc. All rights reserved.
//

import ComposableArchitecture
import Foundation

// MARK: - ReloadableState

/// `Reloadable` module state
///
/// Basically, `ReloadableState` is a type that describes the data
/// `Reloadable` feature needs to perform its logic and render its UI.
@dynamicMemberLookup
public struct ReloadableState<Data: Equatable, ErrorType: Error & Equatable>: Equatable {
    
    // MARK: - Status

    public enum Status: Equatable, Codable {
        case initial
        case loading
        case loaded
        case reloading
        case failure
    }

    // MARK: - AlertMode

    public enum AlertMode: Equatable, Codable {
        case onFailure(shoudDisplayOnReload: Bool)
        case never
    }

    // MARK: - AutoReloadingType

    public enum AutoReloadingType: Equatable, Codable {
        case none
        case immediate
        case defered(interval: TimeInterval = 2, attempts: Int = 3)
    }

    /// Current loading status
    public var status: Status = .initial

    /// Current data of the state
    public var data: Data?

    /// How in failure case data shoud automatically reload
    public var autoReloadingMode: AutoReloadingType = .defered()

    /// How mach reloading attempts happened
    public var reloadingAttemptsCount = 0

    /// Failure alert displaying mode
    public var alertMode: AlertMode = .onFailure(shoudDisplayOnReload: true)

    /// True if loader shoud be displayed while status is `loading`
    public var shouldDisplayLoader = true

    /// Current loader displaying status
    public var isLoaderDisplayed: Bool {
        status == .loading && shouldDisplayLoader
    }

    /// Alert state value
    public var alert: AlertState<ReloadableAction<Data, ErrorType>>?
    
    // MARK: - Initializers
    
    public init(
        status: ReloadableState<Data, ErrorType>.Status = .initial,
        data: Data? = nil,
        autoReloadingMode: ReloadableState<Data, ErrorType>.AutoReloadingType = .defered(),
        reloadingAttemptsCount: Int = 0,
        alertMode: ReloadableState<Data, ErrorType>.AlertMode = .onFailure(shoudDisplayOnReload: true),
        shouldDisplayLoader: Bool = true
    ) {
        self.status = status
        self.data = data
        self.autoReloadingMode = autoReloadingMode
        self.reloadingAttemptsCount = reloadingAttemptsCount
        self.alertMode = alertMode
        self.shouldDisplayLoader = shouldDisplayLoader
    }

    // MARK: - DynamicMemberLookup

    public subscript<Dependency>(dynamicMember keyPath: KeyPath<Data, Dependency>) -> Dependency? {
        data?[keyPath: keyPath]
    }
}
