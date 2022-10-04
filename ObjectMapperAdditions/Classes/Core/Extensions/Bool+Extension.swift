//
//  Bool+Extension.swift
//  ObjectMapperAdditions
//
//  Created by Anton Plebanovich on 28.07.22.
//  Copyright © 2022 Anton Plebanovich. All rights reserved.
//

import Foundation
import RoutableLogger

extension Bool {
    
    static func safeFrom(_ string: String, file: String = #file, function: String = #function, line: UInt = #line) -> Bool? {
        if string.isEmpty {
            logDebug("Received empty string instead of a Bool. Considering it as `nil`.")
            return nil
        }
        
        if let bool = string.asBool {
            return bool
        } else {
            RoutableLogger.logError("Unable to cast String to Bool", data: ["string": string], file: file, function: function, line: line)
            return nil
        }
    }
}
