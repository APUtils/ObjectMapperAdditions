//
//  StringTransform.swift
//  ObjectMapperAdditions
//
//  Created by Anton Plebanovich on 7/17/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import Foundation
import ObjectMapper
import RoutableLogger

/// Transforms value of type Any to String. Tries to typecast if possible.
public class StringTransform: TransformType {
    public typealias Object = String
    public typealias JSON = String
    
    private init() {}
    
    public func transformFromJSON(_ value: Any?) -> Object? {
        if value == nil {
            return nil
        } else if let string = value as? String {
            return string
        } else if let int = value as? Int {
            return String(int)
        } else if let double = value as? Double {
            return String(double)
        } else if let bool = value as? Bool {
            return (bool ? "true" : "false")
        } else if let number = value as? NSNumber {
            return number.stringValue
        } else {
            RoutableLogger.logError("Can not cast value of type \(type(of: value!)) to type \(Object.self)", data: ["value": value])
            return nil
        }
    }
    
    public func transformToJSON(_ value: Object?) -> JSON? {
        return value
    }
}

// ******************************* MARK: - Singletone

public extension StringTransform {
    static let shared = StringTransform()
}
