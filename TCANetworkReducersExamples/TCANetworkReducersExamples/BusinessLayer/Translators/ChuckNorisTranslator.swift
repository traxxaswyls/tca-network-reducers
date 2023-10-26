//
//  ChuckNorisTranslator.swift
//  BusinessLayer
//
//  Created by Gleb Kovalenko on 27.07.2023.
//

import SDAO
import Models
import Monreau
import Foundation

// MARK: - ChuckNorisTranslator

public final class ChuckNorisTranslator {
    
    // MARK: - Aliases
    
    public typealias PlainModel = ChuckNorisPlainObject
    public typealias DatabaseModel = ChuckNorisModelObject
    
    /// ChuckNoris storage
    private lazy var chuckNorisStorage = RealmStorage<ChuckNorisModelObject>(configuration: self.configuration)
    
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

extension ChuckNorisTranslator: Translator {
    
    public func translate(model: DatabaseModel) throws -> PlainModel {
        ChuckNorisPlainObject(
            id: model.id,
            value: model.value
        )
    }
    
    public func translate(plain: PlainModel) throws -> DatabaseModel {
        let model = try chuckNorisStorage.read(byPrimaryKey: plain.uniqueId.rawValue) ?? DatabaseModel()
        try translate(from: plain, to: model)
        return model
    }
    
    public func translate(from plain: PlainModel, to databaseModel: DatabaseModel) throws {
        if databaseModel.uniqueId.isEmpty {
            databaseModel.uniqueId = plain.uniqueId.rawValue
        }
        databaseModel.id = plain.id
        databaseModel.value = plain.value
    }
}
