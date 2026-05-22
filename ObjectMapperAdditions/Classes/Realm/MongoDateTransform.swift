//
//  MongoDateTransform.swift
//  Pods
//
//  Created by Anton Plebanovich on 10.10.21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import Foundation
import ObjectMapper
import RoutableLogger

public final class MongoDateTransform: TransformType {
    public typealias Object = Date
    public typealias JSON = [String: Any]
    
    public static let shared = MongoDateTransform()
    fileprivate init() {}
    
    public func transformFromJSON(_ value: Any?) -> Object? {
        guard let dateDict = value as? JSON,
              let date = dateDict._getMongoDate() else { return nil }
        
        return date
    }
    
    public func transformToJSON(_ value: Object?) -> JSON? {
        if let date = value {
            let timeIntervalMs = date.timeIntervalSince1970 * 1000
            let timestampMs = Int(exactly: timeIntervalMs.rounded())
            return ["$date": ["$numberLong": timestampMs]]
        } else {
            return nil
        }
    }
}

fileprivate extension Dictionary where Key == String {
    func _getMongoDate() -> Date? {
        let dateValue = self["$date"]
        if let dateString = dateValue as? String {
            return ISO8601DateFormatter.default.date(from: dateString)
            ?? ISO8601DateFormatter.withMillisAndTimeZone.date(from: dateString)
            
        } else if let dictionary = dateValue as? [String: Any] {
            if let timestampMilliseconds = dictionary["$numberLong"] as? Int {
                let timestamp = TimeInterval(timestampMilliseconds) / 1000
                return Date(timeIntervalSince1970: timestamp)
            } else if let timestampMilliseconds = dictionary["$numberLong"] as? Int64 {
                let timestamp = TimeInterval(timestampMilliseconds) / 1000
                return Date(timeIntervalSince1970: timestamp)
            }
        }
        
        RoutableLogger.logError("Unable to map Mongo date", data: ["self": self])
        return nil
    }
}
