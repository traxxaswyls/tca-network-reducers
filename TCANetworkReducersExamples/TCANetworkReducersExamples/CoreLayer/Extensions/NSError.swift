//
//  NSError.swift
//  CoreLayer
//
//  Created by Gleb Kovalenko on 30.07.2023.
//

import Foundation

extension NSError {
    
    /// Get response body as JSON object from `userInfo`, if any
    public var responseBodyJSON: Any? {
        userInfo["NSError.userInfo.key.responseBodyJSON"]
    }
    
    /// Get response body as dictionary from `userInfo`, if any
    public var responseBodyJSONDictionary: [String: Any]? {
        guard let json: Any = self.responseBodyJSON else { return nil }
        if let dictionary = json as? [String: Any] {
            return dictionary
        } else {
            return ["data": json]
        }
    }
}
