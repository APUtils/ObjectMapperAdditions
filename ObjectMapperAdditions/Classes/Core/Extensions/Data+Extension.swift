//
//  Data+Extension.swift
//  ObjectMapperAdditions
//
//  Created by Anton Plebanovich on 17.11.21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import Foundation
import RoutableLogger

extension Data {
    
    // ******************************* MARK: - Hex
    
    /// Get HEX string from data. Can be used for sending APNS token to backend.
    var hexString: String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
    
    /// Try to convert data to ASCII string
    var asciiString: String? {
        String(data: self, encoding: String.Encoding.ascii)
    }
    
    /// Try to convert data to UTF8 string
    var utf8String: String? {
        return String(data: self, encoding: String.Encoding.utf8)
    }
    
    /// String representation for data.
    /// Try to decode as UTF8 string at first.
    /// Try to decode as ASCII string at second.
    /// Uses hex representation if data can not be represented as UTF8 or ASCII string.
    var asString: String {
        utf8String ?? asciiString ?? hexString
    }
    
    /// Try to serialize `self` to JSON object and report error if unable.
    func safeSerializeToJSON(file: String = #file, function: String = #function, line: UInt = #line) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: .allowFragments)
        } catch {
            RoutableLogger.logError("Unable to parse date to JSON", error: error, data: ["self": asString], file: file, function: function, line: line)
            return nil
        }
    }
}
