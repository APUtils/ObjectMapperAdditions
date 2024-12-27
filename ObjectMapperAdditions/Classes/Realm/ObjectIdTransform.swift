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

final class ObjectIdTransform: TransformType {
    typealias Object = ObjectId
    typealias JSON = [String: String]
    
    static let shared = ObjectIdTransform()
    fileprivate init() {}
    
    func transformFromJSON(_ value: Any?) -> Object? {
        guard let dateDict = value as? JSON,
              let id = dateDict._getObjectID() else { return nil }
        
        return id
    }
    
    func transformToJSON(_ value: Object?) -> JSON? {
        if let id = value {
            let string = id.stringValue
            return ["$oid": string]
        } else {
            return nil
        }
    }
}

// ******************************* MARK: - Private Extensions

fileprivate extension Dictionary where Key == String {
    
    func _getObjectID() -> ObjectId? {
        guard let idString = _string(forKey: "$oid") else { return nil }
        return try? ObjectId(string: idString)
    }
}

fileprivate extension Dictionary {
    
    func _string(forKey key: Key) -> String? {
        if let string = self[key] as? String {
            return string
        } else if let number = self[key] as? NSNumber {
            return number.stringValue
        } else if let double = self[key] as? Double {
            return String(double)
        } else if let int = self[key] as? Int {
            return String(int)
        } else {
            return nil
        }
    }
}
