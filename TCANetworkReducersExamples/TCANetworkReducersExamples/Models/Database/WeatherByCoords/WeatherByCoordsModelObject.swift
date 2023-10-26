//
//  WeatherByCoordsModelObject.swift
//  Models
//
//  Created by Gleb Kovalenko on 30.07.2023.
//

import SDAO
import RealmSwift
import Foundation

// MARK: - WeatherByCoordsModelObject

public final class WeatherByCoordsModelObject: RealmModel {
    
    // MARK: - Properties
    
    @objc dynamic public var city = ""
    
    @objc dynamic public var state = ""
    
    @objc dynamic public var country = ""
    
    @objc dynamic public var weather: WeatherModelObject?
    
    @objc dynamic public var location: CoordinatesModelObject?
}
