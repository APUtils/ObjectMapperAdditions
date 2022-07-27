//
//  Int+Extension.swift
//  ObjectMapperAdditions
//
//  Created by Anton Plebanovich on 28.07.22.
//  Copyright © 2022 Anton Plebanovich. All rights reserved.
//

import Foundation
import RoutableLogger

extension Int {
    
    static func safeFrom(_ double: Double, file: String = #file, function: String = #function, line: UInt = #line) -> Int? {
        if let int = Int(exactly: double.rounded()) {
            return int
        } else {
            RoutableLogger.logError("Unable to cast Double to Int", data: ["double": double], file: file, function: function, line: line)
            return nil
        }
    }
    
    static func safeFrom(_ string: String, file: String = #file, function: String = #function, line: UInt = #line) -> Int? {
        if let int = Int(string) {
            return int
        } else {
            RoutableLogger.logError("Unable to cast String to Int", data: ["string": string], file: file, function: function, line: line)
            return nil
        }
    }
}
