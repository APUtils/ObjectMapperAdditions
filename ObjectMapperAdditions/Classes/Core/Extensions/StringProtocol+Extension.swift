//
//  StringProtocol+Extension.swift
//  ObjectMapperAdditions
//
//  Created by Anton Plebanovich on 28.07.22.
//  Copyright © 2022 Anton Plebanovich. All rights reserved.
//

import Foundation

extension StringProtocol {
    
    /// Returns `self` as `Bool` if conversion is possible.
    var asBool: Bool? {
        if let bool = Bool(asString) {
            return bool
        }
        
        switch lowercased() {
        case "true", "yes", "1", "enable": return true
        case "false", "no", "0", "disable": return false
        default: return nil
        }
    }
    
    /// Returns `self` as `String`
    var asString: String {
        if let string = self as? String {
            return string
        } else {
            return String(self)
        }
    }
}
