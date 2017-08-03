//
//  IntTransform.swift
//  ObjectMapperAdditions
//
//  Created by Anton Plebanovich on 7/17/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import ObjectMapper


/// Transforms value of type Any to Int. Tries to typecast if possible.
public class IntTransform: TransformType {
    public typealias Object = Int
    public typealias JSON = Int
    
    public init() {}
    
    public func transformFromJSON(_ value: Any?) -> Object? {
        if value == nil {
            return nil
        } else if let int = value as? Int {
            return int
        } else if let double = value as? Double {
            return Int(double)
        } else if let bool = value as? Bool {
            return (bool ? 1 : 0)
        } else if let string = value as? String {
            return Int(string)
        } else if let number = value as? NSNumber {
            return number.intValue
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
