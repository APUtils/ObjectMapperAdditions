//
//  BaseMappable+Additions.swift
//  ObjectMapperAdditions
//
//  Created by Anton Plebanovich on 6/30/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import ObjectMapper


public extension BaseMappable {
    func toJSON(shouldIncludeNilValues: Bool) -> [String: Any] {
        return Mapper(shouldIncludeNilValues: shouldIncludeNilValues).toJSON(self)
    }
    
    /// Returns the JSON Data for the object
    func toJSONData() -> Data? {
        toJSONString(prettyPrint: false)?.data(using: .utf8)
    }
}

public extension Array where Element: BaseMappable {
    func toJSON(shouldIncludeNilValues: Bool) -> [[String: Any]] {
        return Mapper(shouldIncludeNilValues: shouldIncludeNilValues).toJSONArray(self)
    }
    
    /// Returns the JSON Data for the object
    func toJSONData() -> Data? {
        toJSONString(prettyPrint: false)?.data(using: .utf8)
    }

}

public extension Set where Element: BaseMappable {
    func toJSON(shouldIncludeNilValues: Bool) -> [[String: Any]] {
        return Mapper(shouldIncludeNilValues: shouldIncludeNilValues).toJSONSet(self)
    }
    
    /// Returns the JSON Data for the object
    func toJSONData() -> Data? {
        toJSONString(prettyPrint: false)?.data(using: .utf8)
    }
}
