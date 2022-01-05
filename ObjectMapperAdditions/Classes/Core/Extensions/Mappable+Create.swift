//
//  Mappable+Create.swift
//  ObjectMapperAdditions
//
//  Created by Anton Plebanovich on 16.11.21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import Foundation
import ObjectMapper
import RoutableLogger

// ******************************* MARK: - From data

public extension Mappable {
    
    /// Creates model from JSON string.
    /// - parameter jsonData: Data in JSON format to use for model creation.
    /// - throws: `MappingError.emptyData` if response data is empty.
    /// - throws: `MappingError.invalidJSON` if response isn't a valid JSON.
    /// - throws: `MappingError.unknownType` if it wasn't possible to create model.
    static func create(jsonData: Data?, file: String = #file, function: String = #function, line: UInt = #line) throws -> Self {
        guard let jsonData = jsonData, !jsonData.isEmpty else {
            throw MappingError.emptyData
        }
        
        guard jsonData.first == ASCIICodes.openCurlyBracket else {
            throw MappingError.invalidJSON
        }
        
        guard let jsonObject = jsonData.safeSerializeToJSON(file: file, function: function, line: line) else {
            throw MappingError.invalidJSON
        }
        
        guard let jsonDictionary = jsonObject as? [String: Any] else {
            throw MappingError.unknownType
        }
        
        guard let model = Self(JSON: jsonDictionary) else {
            throw MappingError.unknownType
        }
        
        return model
    }
    
    /// Create model from JSON string. Report error and return nil if unable.
    /// - parameter jsonData: Data in JSON format to use for model creation.
    static func safeCreate(jsonData: Data?, file: String = #file, function: String = #function, line: UInt = #line) -> Self? {
        do {
            return try create(jsonData: jsonData)
        } catch {
            RoutableLogger.logError("Unable to create object from JSON data", error: error, data: ["jsonData": jsonData, "self": self], file: file, function: function, line: line)
            return nil
        }
    }
}

// ******************************* MARK: - From string

public extension Mappable {
    
    /// Creates model from JSON string.
    /// - parameter jsonString: String in JSON format to use for model creation.
    /// - throws: `MappingError.emptyData` if response data is empty.
    /// - throws: `MappingError.invalidJSON` if response isn't a valid JSON.
    /// - throws: `MappingError.unknownType` if it wasn't possible to create model.
    static func create(jsonString: String?, file: String = #file, function: String = #function, line: UInt = #line) throws -> Self {
        guard let jsonString = jsonString else {
            throw MappingError.emptyData
        }
        
        guard !jsonString.isEmpty else {
            throw MappingError.emptyData
        }
        
        guard jsonString.first == "{" else {
            throw MappingError.invalidJSON
        }
        
        guard let model = Self(JSONString: jsonString) else {
            throw MappingError.unknownType
        }
        
        return model
    }
    
    /// Create model from JSON string. Report error and return nil if unable.
    /// - parameter jsonString: String in JSON format to use for model creation.
    static func safeCreate(jsonString: String?, file: String = #file, function: String = #function, line: UInt = #line) -> Self? {
        do {
            return try create(jsonString: jsonString)
        } catch {
            RoutableLogger.logError("Unable to create object from JSON string", error: error, data: ["jsonString": jsonString, "self": self], file: file, function: function, line: line)
            return nil
        }
    }
}
