//
//  File.swift
//  
//
//  Created by Dmitry Savinov on 01.08.2023.
//

import Foundation

import Foundation

// MARK: - PaginatedResponse

public protocol PaginatedResponse: Equatable, Decodable {
    
    // MARK: - AssociatedTypes
    
    associatedtype Element: Equatable
    associatedtype Metadata: Decodable & Equatable
    
    // MARK: - Properties
    
    var pagination: Metadata { get }
    var results: [Element] { get }
}
