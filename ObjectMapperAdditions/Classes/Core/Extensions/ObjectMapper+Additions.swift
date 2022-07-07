//
//  ObjectMapper+Additions.swift
//  ObjectMapperAdditions
//
//  Created by Anton Plebanovich on 6/13/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import Foundation
import ObjectMapper

public extension Map {
    /// It asserts that value is presents in JSON. Optional values must be included as <null>.
    func assureValuePresent(forKey key: String) -> Bool {
        if JSON[key] == nil {
            assertionFailure("Mandatory field for key `\(key)` is missing from JSON: \(JSON)")
            
            return false
        }
        
        return true
    }
}

// ******************************* MARK: - To JSON String

public extension BaseMappable {
    
    /// Returns the JSON String for the object
    func toJSONString(options: JSONSerialization.WritingOptions) -> String? {
        let dictionary = Mapper<Self>().toJSON(self)
        return Mapper<Self>.toJSONData(dictionary, options: options)?.utf8String
    }
}

public extension Array where Element: BaseMappable {
    
    /// Returns the JSON String for the object
    func toJSONString(options: JSONSerialization.WritingOptions) -> String? {
        let dictionary = Mapper<Element>().toJSONArray(self)
        return Mapper<Element>.toJSONData(dictionary, options: options)?.utf8String
    }
}

public extension JSONSerialization.WritingOptions {
    
    /// `[.sortedKeys]` on `iOS <13.0` and `[.sortedKeys, .withoutEscapingSlashes]` on `iOS >=13.0`
    static let sortedKeysWithoutEscapingSlashesIfPossible: JSONSerialization.WritingOptions = {
        if #available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *) {
            return [.sortedKeys, .withoutEscapingSlashes]
        } else if #available(macOS 10.13, tvOS 11.0, watchOS 4.0, *) {
            return [.sortedKeys]
        } else {
            return []
        }
    }()
}
