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
        let roundedDouble = double.rounded()
        if let int = Int(exactly: roundedDouble) {
            if roundedDouble != double {
                RoutableLogger.logWarning("[\(file._fileName):\(line)] Double casted to Int with rounding: \(double) -> \(int)")
            }
            
            return int
            
        } else {
            RoutableLogger.logError("Unable to cast Double to Int", data: ["double": double], file: file, function: function, line: line)
            return nil
        }
    }
    
    static func safeFrom(_ string: String, file: String = #file, function: String = #function, line: UInt = #line) -> Int? {
        if string.isNil {
            RoutableLogger.logDebug("[\(file._fileName):\(line)] Received '\(string)' string instead of an Int. Considering it as `nil`.")
            return nil
        }
        
        if let int = Int(string) {
            return int
            
        } else if let double = Double.safeFrom(string, file: file, function: function, line: line) {
            return safeFrom(double, file: file, function: function, line: line)
            
        } else {
            RoutableLogger.logError("Unable to cast String to Int", data: ["string": string], file: file, function: function, line: line)
            return nil
        }
    }
}
