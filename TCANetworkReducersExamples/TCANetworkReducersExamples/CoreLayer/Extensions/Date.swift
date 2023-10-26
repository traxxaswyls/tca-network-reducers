//
//  Date.swift
//  CoreLayer
//
//  Created by Gleb Kovalenko on 30.07.2023.
//

import Foundation

extension Date {
    
    public func dateTo24FormatDateStringWithoutSymbols() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let timeFormatter = DateFormatter()
        timeFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        return [
            dateFormatter.string(from: self),
            timeFormatter.string(from: self)
        ].joined(separator: " at ")
    }
}
