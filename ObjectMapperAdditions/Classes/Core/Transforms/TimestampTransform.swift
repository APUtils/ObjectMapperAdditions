//
//  TimestampTransform.swift
//  ObjectMapperAdditions
//
//  Created by Anton Plebanovich on 9/26/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import Foundation
import ObjectMapper


/// Transforms UNIX timestamp (aka POSIX timestamp or epoch) to/from Date.
public class TimestampTransform: TransformType {
    public typealias Object = Date
    public typealias JSON = Int
    
    private init() {}
    
    public func transformFromJSON(_ value: Any?) -> Object? {
        guard let timestamp = DoubleTransform.shared.transformFromJSON(value) else { return nil }
        
        let date = Date(timeIntervalSince1970: timestamp)
        
        return date
    }
    
    public func transformToJSON(_ value: Object?) -> JSON? {
        guard let timestamp = value?.timeIntervalSince1970 else { return nil }
        
        return Int(timestamp)
    }
}

// ******************************* MARK: - Singletone

public extension TimestampTransform {
    static let shared = TimestampTransform()
}
