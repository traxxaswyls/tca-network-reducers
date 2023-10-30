//
//  ReloadableAction.swift
//  Ruvpro
//
//  Created by TraxxasWyls on 01/07/2022.
//  Copyright © 2022 Incetro Inc. All rights reserved.
//

import Foundation
import ComposableArchitecture

// MARK: - ReloadableAction

/// All available `Reloadable` module actions.
///
/// It's a type that represents all of the actions that can happen in `Reloadable` feature,
/// such as user actions, notifications, event sources and more.
///
/// We have some actions in the feature. There are the obvious actions,
/// such as tapping some button, holding another button, or changing a slider value.
/// But there are also some slightly non-obvious ones, such as the action of the user dismissing the alert,
/// and the action that occurs when we receive a response from the fact API request.
public enum ReloadableAction<Data: Equatable & Codable, ErrorType: Error & Equatable>: Equatable {

    // MARK: - Cases

    /// An action that calls when target response has been received from cache closure
    case cacheResponse(Result<Data?, ErrorType>)

    /// An action that calls when target response has been received from loader closure
    case response(Result<Data, ErrorType>)

    /// An action that entails loading of the data
    case load

    /// An action that entails reloading of the data
    case reload

    /// An action that calls when loading status is changed
    case loadingInProgress(Bool)

    /// An action that calls when user taps on the `dismiss` button on the alert
    case alertDismissed
}
