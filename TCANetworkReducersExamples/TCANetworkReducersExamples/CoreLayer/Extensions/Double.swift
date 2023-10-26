//
//  Double.swift
//  CoreLayer
//
//  Created by Gleb Kovalenko on 30.07.2023.
//

import Foundation

// MARK: - Double

extension Double {
    
    public func format(_ format: String, dropZeroFraction: Bool = true) -> String {
        let result = String(format: "%\(format)f", self)
        return floor(self) == self ? "\(Int(self))" : result
    }
    
    /// Format double with decimal and group separators
    public var formattedWithDotSeparator: String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = "."
        formatter.maximumFractionDigits = 1
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}
