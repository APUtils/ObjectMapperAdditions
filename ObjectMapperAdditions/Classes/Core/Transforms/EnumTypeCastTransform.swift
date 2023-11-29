//
//  EnumTypeCastTransform.swift
//  ObjectMapperAdditions
//
//  Created by Anton Plebanovich on 7/17/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import ObjectMapper
import RoutableLogger

/// Transforms value of type Any to RawRepresentable enum. Tries to typecast if possible.
public class EnumTypeCastTransform<T: RawRepresentable>: TransformType {
    public typealias Object = T
    public typealias JSON = T.RawValue
    
    public init() {}
    
    open func transformFromJSON(_ value: Any?) -> T? {
        guard let value else { return nil }
        
        if let value = value as? T.RawValue {
            let result = T(rawValue: value)
            reportUnknownCaseIfNeeded(result, value: value, rawValue: nil)
            return result
            
        } else if T.RawValue.self == Int.self {
            let rawValue = IntTransform.shared.transformFromJSON(value) as? T.RawValue
            let result = rawValue.flatMap(T.init(rawValue:))
            reportUnknownCaseIfNeeded(result, value: value, rawValue: rawValue)
            return result
            
        } else if T.RawValue.self == Double.self {
            let rawValue = DoubleTransform.shared.transformFromJSON(value) as? T.RawValue
            let result = rawValue.flatMap(T.init(rawValue:))
            reportUnknownCaseIfNeeded(result, value: value, rawValue: rawValue)
            return result
            
        } else if T.RawValue.self == Bool.self {
            let rawValue = BoolTransform.shared.transformFromJSON(value) as? T.RawValue
            let result = rawValue.flatMap(T.init(rawValue:))
            reportUnknownCaseIfNeeded(result, value: value, rawValue: rawValue)
            return result
            
        } else if T.RawValue.self == String.self {
            let rawValue = StringTransform.shared.transformFromJSON(value) as? T.RawValue
            let result = rawValue.flatMap(T.init(rawValue:))
            reportUnknownCaseIfNeeded(result, value: value, rawValue: rawValue)
            return result
            
        } else {
            RoutableLogger.logError("Can not cast value of type \(type(of: value)) to type \(T.RawValue.self)", data: ["value": value])
            return nil
        }
    }
    
    open func transformToJSON(_ value: T?) -> T.RawValue? {
        if let obj = value {
            return obj.rawValue
        }
        return nil
    }
    
    private func reportUnknownCaseIfNeeded(_ result: T?, value: Any, rawValue: Any?) {
        if result == nil {
            RoutableLogger.logError("Unknown enum case", data: ["value": value, "rawValue": rawValue])
        }
    }
}
