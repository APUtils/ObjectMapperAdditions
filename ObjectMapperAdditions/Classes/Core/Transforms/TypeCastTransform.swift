//
//  TypeCastTransform.swift
//  ObjectMapperAdditions
//
//  Created by Anton Plebanovich on 7/21/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import ObjectMapper


/// Transforms value of type Any to generic type. Tries to typecast if possible.
public class TypeCastTransform<T>: TransformType {
    public typealias Object = T
    public typealias JSON = T
    
    public init() {}
    
    public func transformFromJSON(_ value: Any?) -> Object? {
        if value == nil {
            return nil
        } else if let value = value as? T {
            return value
        } else if T.self == Int.self {
            return IntTransform().transformFromJSON(value) as? T
        } else if T.self == Double.self {
            return DoubleTransform().transformFromJSON(value) as? T
        } else if T.self == Bool.self {
            return BoolTransform().transformFromJSON(value) as? T
        } else if T.self == String.self {
            return StringTransform().transformFromJSON(value) as? T
        } else {
            print("ObjectMapperAdditions. Can not cast value \(value!) of type \(type(of: value!)) to type \(T.self)")
            
            return nil
        }
    }
    
    public func transformToJSON(_ value: Object?) -> JSON? {
        return value
    }
}
