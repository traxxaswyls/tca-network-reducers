//
//  DAODependencies.swift
//  BusinessLayer
//
//  Created by Gleb Kovalenko on 28.07.2023.
//

import Foundation
import TCA
import Monreau
import Models

// MARK: - DependencyValues

extension DependencyValues {
    
    // MARK: - ChuckNorisDAO
    
    /// The current `ChuckNorisDAO` that features should use when handling interactions.
    public var chuckNorisDAO: ChuckNorisDAO {
        get { self[ChuckNorisDAOKey.self] }
        set { self[ChuckNorisDAOKey.self] = newValue }
    }
    
    // MARK: - DependencyKey
    
    /// Dependecy key for `ChuckNorisDAO` instance
    private enum ChuckNorisDAOKey: DependencyKey {
        static let liveValue = ChuckNorisDAO(
            storage: RealmStorage<ChuckNorisModelObject>(
                configuration: Dependency(\.realmConfiguration).wrappedValue
            ),
            translator: Models.ChuckNorisTranslator(
                configuration: Dependency(\.realmConfiguration).wrappedValue
            )
        )
    }
}
