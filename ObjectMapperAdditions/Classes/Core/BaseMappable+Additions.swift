//
//  BaseMappable+Additions.swift
//  ObjectMapperAdditions
//
//  Created by Anton Plebanovich on 6/30/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import ObjectMapper


public extension BaseMappable {
    public func toJSON(shouldIncludeNilValues: Bool) -> [String: Any] {
        return Mapper(shouldIncludeNilValues: shouldIncludeNilValues).toJSON(self)
    }
}

public extension Array where Element: BaseMappable {
    public func toJSON(shouldIncludeNilValues: Bool) -> [[String: Any]] {
        return Mapper(shouldIncludeNilValues: shouldIncludeNilValues).toJSONArray(self)
    }
}

public extension Set where Element: BaseMappable {
    public func toJSON(shouldIncludeNilValues: Bool) -> [[String: Any]] {
        return Mapper(shouldIncludeNilValues: shouldIncludeNilValues).toJSONSet(self)
    }
}
