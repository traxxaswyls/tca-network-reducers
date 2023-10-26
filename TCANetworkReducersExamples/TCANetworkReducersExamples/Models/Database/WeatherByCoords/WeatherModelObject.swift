//
//  WeatherModelObject.swift
//  Models
//
//  Created by Gleb Kovalenko on 30.07.2023.
//

import SDAO
import RealmSwift
import Foundation

// MARK: - WeatherModelObject

public final class WeatherModelObject: RealmModel {
    
    // MARK: - Properties
    
    @objc dynamic public var timestamp = 0.0
    
    @objc dynamic public var temperature = 0
    
    @objc dynamic public var pressure = 0
    
    @objc dynamic public var humidity = 0
    
    @objc dynamic public var windSpeed = 0.0
}
