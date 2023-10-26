//
//  ChuckNorisModelObject.swift
//  TCANetworkReducersExamples
//
//  Created by Gleb Kovalenko on 27.07.2023.
//

import SDAO
import RealmSwift
import Foundation

// MARK: - ChuckNorisModelObject

public final class ChuckNorisModelObject: RealmModel {
    
    // MARK: - Properties
    
    @objc dynamic public var id = ""
    
    @objc dynamic public var value = ""
}
