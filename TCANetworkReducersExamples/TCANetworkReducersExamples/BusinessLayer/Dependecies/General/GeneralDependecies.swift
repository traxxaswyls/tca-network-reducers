//
//  GeneralDependecies.swift
//  BusinessLayer
//
//  Created by Gleb Kovalenko on 27.07.2023.
//

import TCA
import Foundation
import Monreau

// MARK: - DependencyValues

extension DependencyValues {
    
    // MARK: - RealmConfiguration
    
    /// The current `RealmConfiguration` that features should use when handling interactions.
    public var realmConfiguration: RealmConfiguration {
        get { self[RealmConfigurationKey.self] }
        set { self[RealmConfigurationKey.self] = newValue }
    }
    
    // MARK: - DependencyKey
    
    /// Dependecy key for `RealmConfiguration` instance
    private enum RealmConfigurationKey: DependencyKey {
        static let liveValue = RealmConfiguration(
            databaseFileName: "NetworkReducers.realm",
            databaseVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
            }
        )
    }
}
