//
//  GeneralDependecies.swift
//  Chibiverse
//
//  Created by Dmitry Savinov on 07.03.2023.
//

import TCA
import Foundation

// MARK: - DependencyValues

extension DependencyValues {
    
    // MARK: - MainQueueScheduler
        
    /// The current `ChibiTranslator` that features should use when handling interactions.
    internal var mainQueueScheduler: AnySchedulerOf<DispatchQueue> {
        get { self[MainQueueSchedulerKey.self] }
        set { self[MainQueueSchedulerKey.self] = newValue }
    }
    
    // MARK: - DependencyKey
    
    /// Dependecy key for `MainQueueScheduler` instance
    private enum MainQueueSchedulerKey: DependencyKey {
        static let liveValue = DispatchQueue.main.eraseToAnyScheduler()
    }
}
