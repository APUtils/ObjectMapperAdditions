//
//  ObjectMapper+Additions.swift
//  ObjectMapperAdditions
//
//  Created by Anton Plebanovich on 6/13/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import ObjectMapper


public extension Map {
    /// It asserts that value is presents in JSON. Optional values must be included as <null>.
    public func assureValuePresent(forKey key: String) -> Bool {
        if JSON[key] == nil {
            assertionFailure("Mandatory field for key `\(key)` is missing from JSON: \(JSON)")
            
            return false
        }
        
        return true
    }
}
