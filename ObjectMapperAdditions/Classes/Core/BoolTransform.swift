//
//  BoolTransform.swift
//  ObjectMapperAdditions
//
//  Created by Anton Plebanovich on 7/17/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import ObjectMapper


/// Transforms value of type Any to Bool. Tries to typecast if possible.
public class BoolTransform: TransformType {
    public typealias Object = Bool
    public typealias JSON = Bool
    
    public init() {}
    
    public func transformFromJSON(_ value: Any?) -> Object? {
        if value == nil {
            return nil
        } else if let bool = value as? Bool {
            return bool
        } else if let int = value as? Int {
            return (int != 0)
        } else if let double = value as? Double {
            return (double != 0)
        } else if let string = value as? String {
            return Bool(string)
        } else if let number = value as? NSNumber {
            return number.boolValue
        } else {
            #if DEBUG
                print("Can not cast value \(value!) of type \(type(of: value!)) to type \(Object.self)")
            #endif
            
            return nil
        }
    }
    
    public func transformToJSON(_ value: Object?) -> JSON? {
        return value
    }
}
