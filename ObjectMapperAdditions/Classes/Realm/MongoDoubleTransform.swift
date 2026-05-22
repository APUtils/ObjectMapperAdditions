//
//  MongoDoubleTransform.swift
//  Pods
//
//  Created by Anton Plebanovich on 22.05.26.
//  Copyright © 2026 Anton Plebanovich. All rights reserved.
//

import Foundation
import ObjectMapper
#if !COCOAPODS
import ObjectMapperAdditions
#endif

public class MongoDoubleTransform: TransformType {
    public typealias Object = Double
    public typealias JSON = Double
    
    public static let shared = MongoDoubleTransform()
    private init() {}
    
    public func transformFromJSON(_ value: Any?) -> Object? {
        if value == nil {
            return nil
            
        } else if let dictionary = value as? [String: Any] {
            if let double = dictionary._double(forKey: "$numberDouble") {
                return double
            } else if dictionary._int(forKey: "$undefined") == 1 {
                return nil
            } else {
                fatalError("Can not cast value of type \(type(of: value!)) to type \(Object.self). Unknown dictionary format: \(dictionary)")
            }
            
        } else if let double = DoubleTransform.shared.transformFromJSON(value) {
            return double
            
        } else {
            fatalError("Can not cast value of type \(type(of: value!)) to type \(Object.self): \(String(describing: value))")
        }
    }
    
    public func transformToJSON(_ value: Object?) -> JSON? {
        return value
    }
}
