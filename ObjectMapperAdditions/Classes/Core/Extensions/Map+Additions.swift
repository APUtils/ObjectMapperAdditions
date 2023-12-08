//
//  Map+Additions.swift
//  Pods
//
//  Created by Anton Plebanovich on 8.12.23.
//  Copyright © 2023 Anton Plebanovich. All rights reserved.
//

import ObjectMapper

public extension Map {
    
    func boolValue(_ key: String) -> Bool? {
        try? value(key, using: BoolTransform.shared)
    }
    
    func doubleValue(_ key: String) -> Double? {
        try? value(key, using: DoubleTransform.shared)
    }
    
    func intValue(_ key: String) -> Int? {
        try? value(key, using: IntTransform.shared)
    }
    
    func stringValue(_ key: String) -> String? {
        try? value(key, using: StringTransform.shared)
    }
    
    func value<T: BaseMappable>(_ type: T.Type, key: String) -> T? {
        try? value(key)
    }
    
    func value<T: BaseMappable>(_ type: [T].Type, key: String) -> [T]? {
        try? value(key)
    }
    
    func typeCastedValue<T>(_ type: T.Type, key: String) -> T? {
        try? value(key, using: TypeCastTransform())
    }
    
    func typeCastedValue<T: RawRepresentable>(_ type: T.Type, key: String) -> T? {
        try? value(key, using: EnumTypeCastTransform())
    }
}
