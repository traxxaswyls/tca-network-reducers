//
//  PaginationAction.swift
//  TheRun
//
//  Created by TraxxasWyls on 28/07/2022.
//  Copyright © 2022 Incetro Inc. All rights reserved.
//

import Foundation

// MARK: - PaginationAction

/// All available `Pagination` module actions.
///
/// It's a type that represents all of the actions that can happen in `Pagination` feature,
/// such as user actions, notifications, event sources and more.
///
/// We have some actions in the feature. There are the obvious actions,
/// such as tapping some button, holding another button, or changing a slider value.
/// But there are also some slightly non-obvious ones, such as the action of the user dismissing the alert,
/// and the action that occurs when we receive a response from the fact API request.
public enum PaginationAction<Response: PaginatedResponse, ErrorType: Error & Equatable>: Equatable {

    // MARK: - Cases

    /// An action that calls when target response has been received.
    case response(Result<Response, ErrorType>)

    /// The action is called after the pagination fetches all objects from all pages.
    /// Here you can add functionality to handle data after all the objects have been received.
    case allElementsFetched

    /// The reset is called after the pagination has been reset.
    case reset

    /// The action is called when pagination helper view is appeared.
    /// After that, the fetch closure from environment is called.
    case paginate
}
