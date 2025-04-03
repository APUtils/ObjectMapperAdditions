//
//  Dictionary+Additions.swift
//  Pods
//
//  Created by Anton Plebanovich on 27.12.24.
//  Copyright © 2024 Anton Plebanovich. All rights reserved.
//

import Foundation

extension Dictionary where Key == String {
    func _getMongoDate() -> Date? {
        guard let dateString = self._string(forKey: "$date") else { return nil }
        return ISO8601DateFormatter.default.date(from: dateString)
    }
}

extension Dictionary {
    
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
