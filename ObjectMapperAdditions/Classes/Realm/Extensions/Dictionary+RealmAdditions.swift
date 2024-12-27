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
        guard let idString = _string(forKey: "$oid") else { return nil }
        return try? ObjectId(string: idString)
    }
}
