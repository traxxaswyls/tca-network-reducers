//
//  CoordinatesTranslator.swift
//  BusinessLayer
//
//  Created by Gleb Kovalenko on 30.07.2023.
//

import SDAO
import Models
import Monreau
import Foundation

// MARK: - CoordinatesTranslator

public final class CoordinatesTranslator {
    
    // MARK: - Aliases
    
    public typealias PlainModel = CoordinatesPlainObject
    public typealias DatabaseModel = CoordinatesModelObject
    
    /// Coordinates storage
    private lazy var coordinatesStorage = RealmStorage<CoordinatesModelObject>(configuration: self.configuration)
    
    /// RealmConfiguration instance
    private let configuration: RealmConfiguration
    
    // MARK: - Initializers
    
    /// Default initializer
    /// - Parameters:
    ///   - configuration: current realm db config
    public init(configuration: RealmConfiguration) {
        self.configuration = configuration
    }
}

// MARK: - Translator

extension CoordinatesTranslator: Translator {
    
    public func translate(model: DatabaseModel) throws -> PlainModel {
        CoordinatesPlainObject(
            lat: model.lat,
            lon: model.lon
        )
    }
    
    public func translate(plain: PlainModel) throws -> DatabaseModel {
        let model = try coordinatesStorage.read(byPrimaryKey: plain.uniqueId.rawValue) ?? DatabaseModel()
        try translate(from: plain, to: model)
        return model
    }
    
    public func translate(from plain: PlainModel, to databaseModel: DatabaseModel) throws {
        if databaseModel.uniqueId.isEmpty {
            databaseModel.uniqueId = plain.uniqueId.rawValue
        }
        databaseModel.lat = plain.lat
        databaseModel.lon = plain.lon
    }
}
