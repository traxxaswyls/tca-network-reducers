//
//  CoordinatesModelObject.swift
//  Models
//
//  Created by Gleb Kovalenko on 30.07.2023.
//

import SDAO
import RealmSwift
import Foundation

// MARK: - CoordinatesModelObject

public final class CoordinatesModelObject: RealmModel {
    
    // MARK: - Properties
    
    @objc dynamic public var lat = 0.0
    
    @objc dynamic public var lon = 0.0
}
