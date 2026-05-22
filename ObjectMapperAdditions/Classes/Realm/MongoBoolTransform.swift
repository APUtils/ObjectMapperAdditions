//
//  MongoBoolTransform.swift
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

public class MongoBoolTransform: TransformType {
    public typealias Object = Bool
    public typealias JSON = Bool
    
    public static let shared = MongoBoolTransform()
    private init() {}
    
    public func transformFromJSON(_ value: Any?) -> Object? {
        if value == nil {
            return nil
            
        } else if let dictionary = value as? [String: Any] {
            if dictionary._int(forKey: "$undefined") == 1 {
                return nil
            } else {
                fatalError("Can not cast value of type \(type(of: value!)) to type \(Object.self). Unknown dictionary format: \(dictionary)")
            }
            
        } else if let bool = BoolTransform.shared.transformFromJSON(value) {
            return bool
            
        } else {
            fatalError("Can not cast value of type \(type(of: value!)) to type \(Object.self): \(String(describing: value))")
        }
    }
    
    public func transformToJSON(_ value: Object?) -> JSON? {
        return value
    }
}
