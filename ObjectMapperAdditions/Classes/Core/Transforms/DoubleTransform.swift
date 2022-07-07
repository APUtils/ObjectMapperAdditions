//
//  DoubleTransform.swift
//  ObjectMapperAdditions
//
//  Created by Anton Plebanovich on 7/17/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import Foundation
import ObjectMapper
import RoutableLogger

/// Transforms value of type Any to Double. Tries to typecast if possible.
public class DoubleTransform: TransformType {
    public typealias Object = Double
    public typealias JSON = Double
    
    public init() {}
    
    public func transformFromJSON(_ value: Any?) -> Object? {
        if value == nil {
            return nil
        } else if let double = value as? Double {
            return double
        } else if let int = value as? Int {
            return Double(int)
        } else if let bool = value as? Bool {
            return (bool ? 1.0 : 0.0)
        } else if let string = value as? String {
            return Double(string)
        } else if let number = value as? NSNumber {
            return number.doubleValue
        } else {
            RoutableLogger.logError("Can not cast value of type \(type(of: value!)) to type \(Object.self)", data: ["value": value])
            return nil
        }
    }
    
    public func transformToJSON(_ value: Object?) -> JSON? {
        return value
    }
}
