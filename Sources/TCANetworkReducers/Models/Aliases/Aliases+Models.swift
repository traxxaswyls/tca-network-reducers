//
//  Aliases+Models.swift
//  TheRun
//
//  Created by Dmitry Savinov on 18.02.2023.
//  Copyright © 2023 Incetro Inc. All rights reserved.
//

import Foundation

// MARK: - Aliases

public typealias Paginated<T: Equatable> = PaginatedResponsePlainObject<T>
public typealias DefaultPaginationState<Element: Equatable> = PaginationState<PaginatedResponsePlainObject<Element>>
public typealias DefaultIDPaginationState<Element: Equatable, ID: Equatable> = IDPaginationState<PaginatedResponsePlainObject<Element>, ID>
