//
//  ObjectIdTransform.swift
//  Pods
//
//  Created by Anton Plebanovich on 12.12.21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

public final class ObjectIdTransform: TransformType {
    public typealias Object = ObjectId
    public typealias JSON = [String: String]
    
    public static let shared = ObjectIdTransform()
    
    fileprivate init() {}
    
    public func transformFromJSON(_ value: Any?) -> Object? {
        guard let dateDict = value as? JSON,
              let id = dateDict._getObjectID() else { return nil }
        
        return id
    }
    
    public func transformToJSON(_ value: Object?) -> JSON? {
        if let id = value {
            let string = id.stringValue
            return ["$oid": string]
        } else {
            return nil
        }
    }
}
