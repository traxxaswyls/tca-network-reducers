//
//  DateFormatter.swift
//  CoreLayer
//
//  Created by Gleb Kovalenko on 30.07.2023.
//

import Foundation

// MARK: - DateFormatter

extension DateFormatter {
    
    public static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
