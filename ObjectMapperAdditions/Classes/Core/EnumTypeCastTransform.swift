//
//  EnumTypeCastTransform.swift
//  ObjectMapperAdditions
//
//  Created by Anton Plebanovich on 7/17/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import ObjectMapper


/// Transforms value of type Any to RawRepresentable enum. Tries to typecast if possible.
public class EnumTypeCastTransform<T: RawRepresentable>: TransformType {
    public typealias Object = T
    public typealias JSON = T.RawValue
    
    public init() {}
    
    open func transformFromJSON(_ value: Any?) -> T? {
        if value == nil {
            return nil
        } else if let value = value as? T.RawValue {
            return T(rawValue: value)
        } else if T.RawValue.self == Int.self {
            let rawValue = IntTransform().transformFromJSON(value) as? T.RawValue
            return rawValue.flatMap(T.init(rawValue:))
        } else if T.RawValue.self == Double.self {
            let rawValue = DoubleTransform().transformFromJSON(value) as? T.RawValue
            return rawValue.flatMap(T.init(rawValue:))
        } else if T.RawValue.self == Bool.self {
            let rawValue = BoolTransform().transformFromJSON(value) as? T.RawValue
            return rawValue.flatMap(T.init(rawValue:))
        } else if T.RawValue.self == String.self {
            let rawValue = StringTransform().transformFromJSON(value) as? T.RawValue
            return rawValue.flatMap(T.init(rawValue:))
        } else {
            print("ObjectMapperAdditions. Can not cast value \(value!) of type \(type(of: value!)) to type \(T.RawValue.self)")
            return nil
        }
    }
    
    open func transformToJSON(_ value: T?) -> T.RawValue? {
        if let obj = value {
            return obj.rawValue
        }
        return nil
    }
}
