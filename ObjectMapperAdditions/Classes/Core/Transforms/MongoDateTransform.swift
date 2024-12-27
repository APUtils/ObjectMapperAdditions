//
//  MongoDateTransform.swift
//  Pods
//
//  Created by Anton Plebanovich on 10.10.21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import Foundation
import ObjectMapper

public final class MongoDateTransform: TransformType {
    public typealias Object = Date
    public typealias JSON = [String: String]
    
    public static let shared = MongoDateTransform()
    fileprivate init() {}
    
    public func transformFromJSON(_ value: Any?) -> Object? {
        guard let dateDict = value as? JSON,
              let date = dateDict._getMongoDate() else { return nil }
        
        return date
    }
    
    public func transformToJSON(_ value: Object?) -> JSON? {
        if let date = value {
            let string = ISO8601DateFormatter.default.string(from: date)
            return ["$date": string]
        } else {
            return nil
        }
    }
}
