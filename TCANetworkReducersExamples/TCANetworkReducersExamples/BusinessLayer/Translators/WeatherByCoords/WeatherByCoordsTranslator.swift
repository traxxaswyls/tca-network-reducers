//
//  WeatherByCoordsTranslator.swift
//  BusinessLayer
//
//  Created by Gleb Kovalenko on 30.07.2023.
//

import SDAO
import Models
import Monreau
import Foundation

// MARK: - WeatherByCoordsTranslator

public final class WeatherByCoordsTranslator {
    
    // MARK: - Aliases
    
    public typealias PlainModel = WeatherByCoordsPlainObject
    public typealias DatabaseModel = WeatherByCoordsModelObject
    
    /// WeatherByCoords storage
    private lazy var weatherByCoordsStorage = RealmStorage<WeatherByCoordsModelObject>(configuration: self.configuration)
    
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

extension WeatherByCoordsTranslator: Translator {
    
    public func translate(model: DatabaseModel) throws -> PlainModel {
        guard let weather = model.weather else {
            throw NSError(
                domain: "com.incetro.weathermodelobject-translator",
                code: 1000,
                userInfo: [
                    NSLocalizedDescriptionKey: "Cannot find WeatherModelObject instance for WeatherByCoordsPlainObject with id: '\(model.uniqueId)'"
                ]
            )
        }
        guard let location = model.location else {
            throw NSError(
                domain: "com.incetro.weathermodelobject-translator",
                code: 1000,
                userInfo: [
                    NSLocalizedDescriptionKey: "Cannot find CoordinatesModelObject instance for WeatherByCoordsPlainObject with id: '\(model.uniqueId)'"
                ]
            )
        }
        return WeatherByCoordsPlainObject(
            city: model.city,
            state: model.state,
            country: model.country,
            weather: try WeatherTranslator(configuration: configuration).translate(model: weather),
            location: try CoordinatesTranslator(configuration: configuration).translate(model: location)
        )
    }
    
    public func translate(plain: PlainModel) throws -> DatabaseModel {
        let model = try weatherByCoordsStorage.read(byPrimaryKey: plain.uniqueId.rawValue) ?? DatabaseModel()
        try translate(from: plain, to: model)
        return model
    }
    
    public func translate(from plain: PlainModel, to databaseModel: DatabaseModel) throws {
        if databaseModel.uniqueId.isEmpty {
            databaseModel.uniqueId = plain.uniqueId.rawValue
        }
        databaseModel.city = plain.city
        databaseModel.state = plain.state
        databaseModel.country = plain.country
        databaseModel.weather = try WeatherTranslator(configuration: configuration).translate(plain: plain.weather)
        databaseModel.location = try CoordinatesTranslator(configuration: configuration).translate(plain: plain.location)
    }
}
