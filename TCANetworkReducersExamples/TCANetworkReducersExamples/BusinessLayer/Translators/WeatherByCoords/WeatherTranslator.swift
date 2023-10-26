//
//  WeatherTranslator.swift
//  BusinessLayer
//
//  Created by Gleb Kovalenko on 30.07.2023.
//

import SDAO
import Models
import Monreau
import Foundation

// MARK: - WeatherTranslator

public final class WeatherTranslator {
    
    // MARK: - Aliases
    
    public typealias PlainModel = WeatherPlainObject
    public typealias DatabaseModel = WeatherModelObject
    
    /// Weather storage
    private lazy var weatherStorage = RealmStorage<WeatherModelObject>(configuration: self.configuration)
    
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

extension WeatherTranslator: Translator {
    
    public func translate(model: DatabaseModel) throws -> PlainModel {
        WeatherPlainObject(
            timestamp: Date(timeIntervalSince1970: model.timestamp),
            temperature: model.temperature,
            pressure: model.pressure,
            humidity: model.humidity,
            windSpeed: model.windSpeed
        )
    }
    
    public func translate(plain: PlainModel) throws -> DatabaseModel {
        let model = try weatherStorage.read(byPrimaryKey: plain.uniqueId.rawValue) ?? DatabaseModel()
        try translate(from: plain, to: model)
        return model
    }
    
    public func translate(from plain: PlainModel, to databaseModel: DatabaseModel) throws {
        if databaseModel.uniqueId.isEmpty {
            databaseModel.uniqueId = plain.uniqueId.rawValue
        }
        databaseModel.timestamp = plain.timestamp.timeIntervalSince1970
        databaseModel.windSpeed = plain.windSpeed
        databaseModel.humidity = plain.humidity
        databaseModel.pressure = plain.pressure
        databaseModel.temperature = plain.temperature
    }
}
