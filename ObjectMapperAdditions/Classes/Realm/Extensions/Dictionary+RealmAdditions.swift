//
//  Dictionary+RealmAdditions.swift
//  Pods
//
//  Created by Anton Plebanovich on 27.12.24.
//  Copyright © 2024 Anton Plebanovich. All rights reserved.
//

import Foundation
import RealmSwift

extension Dictionary where Key == String {
    func _getObjectID() -> ObjectId? {
        guard let idString = self["$oid"] as? String else { return nil }
        return try? ObjectId(string: idString)
    }
    
    func _int(forKey key: Key) -> Int? {
        if let int = self[key] as? Int {
            return int
        } else if let number = self[key] as? NSNumber {
            return number.intValue
        } else if let string = self[key] as? String {
            return Int(string)
        } else if let double = self[key] as? Double {
            return Int(double)
        } else {
            return nil
        }
    }
    
    func _double(forKey key: Key) -> Double? {
        if let double = self[key] as? Double {
            return double
        } else if let number = self[key] as? NSNumber {
            return number.doubleValue
        } else if let string = self[key] as? String {
            return Double(string)
        } else if let int = self[key] as? Int {
            return Double(int)
        } else {
            return nil
        }
    }
}
