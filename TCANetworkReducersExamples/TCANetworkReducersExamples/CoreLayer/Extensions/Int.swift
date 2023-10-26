//
//  Int.swift
//  CoreLayer
//
//  Created by Gleb Kovalenko on 30.07.2023.
//

import Foundation

// MARK: - Int

extension Int {
    
    /// Format integer
    public var formattedWithEmptySeparator: String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ""
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}
