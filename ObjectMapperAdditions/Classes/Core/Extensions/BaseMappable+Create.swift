//
//  BaseMappable+Create.swift
//  ObjectMapperAdditions
//
//  Created by Anton Plebanovich on 16.11.21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import Foundation
import ObjectMapper
import RoutableLogger

// ******************************* MARK: - [BaseMappable] with data

public extension Array where Element: BaseMappable {
    
    /// Creates models array from JSON string.
    /// - parameter jsonData: Data in JSON format to use for model creation.
    /// - throws: `MappingError.emptyData` if response data is empty.
    /// - throws: `MappingError.invalidJSON` if response isn't a valid JSON.
    /// - throws: `MappingError.unknownType` if it wasn't possible to create model.
    static func create(jsonData: Data?, file: String = #file, function: String = #function, line: UInt = #line) throws -> Array {
        guard let jsonData = jsonData, !jsonData.isEmpty else {
            throw MappingError.emptyData
        }
        
        // Start check
        guard jsonData.firstNonWhitespaceByte == ASCIICodes.openSquareBracket else {
            throw MappingError.invalidJSON(message: "JSON array should start with the '[' character")
        }
        
        // End check
        guard jsonData.lastNonWhitespaceByte == ASCIICodes.closeSquareBracket else {
            throw MappingError.invalidJSON(message: "JSON array should end with the ']' character")
        }
        
        guard let jsonObject = jsonData.safeSerializeToJSON(file: file, function: function, line: line) else {
            throw MappingError.invalidJSON(message: "Unable to serialize JSON array from the data")
        }
        
        guard let jsonArrayOfDictionaries = jsonObject as? [[String: Any]] else {
            throw MappingError.unknownType
        }
        
        let array = Mapper<Element>().mapArray(JSONArray: jsonArrayOfDictionaries)
        
        return array
    }
    
    /// Create models array from JSON string. Report error and return nil if unable.
    /// - parameter jsonData: Data in JSON format to use for model creation.
    static func safeCreate(jsonData: Data?, file: String = #file, function: String = #function, line: UInt = #line) -> Array? {
        do {
            return try create(jsonData: jsonData)
        } catch {
            RoutableLogger.logError("Unable to create array of objects from JSON data", error: error, data: ["jsonData": jsonData?.asString], file: file, function: function, line: line)
            return nil
        }
    }
}

// ******************************* MARK: - [BaseMappable] with string

public extension Array where Element: BaseMappable {
    
    /// Creates models array from JSON string.
    /// - parameter jsonString: String in JSON format to use for model creation.
    /// - throws: `MappingError.emptyData` if response data is empty.
    /// - throws: `MappingError.invalidJSON` if response isn't a valid JSON.
    /// - throws: `MappingError.unknownType` if it wasn't possible to create model.
    static func create(jsonString: String?, file: String = #file, function: String = #function, line: UInt = #line) throws -> Array {
        guard let jsonString = jsonString else {
            throw MappingError.emptyData
        }
        
        guard !jsonString.isEmpty else {
            throw MappingError.emptyData
        }
        
        // Start check
        guard jsonString.firstNonWhitespaceCharacter == "[" else {
            throw MappingError.invalidJSON(message: "JSON array should start with the '[' character")
        }
        
        // End check
        guard jsonString.lastNonWhitespaceCharacter == "]" else {
            throw MappingError.invalidJSON(message: "JSON array should end with the ']' character")
        }
        
        guard let array = Mapper<Element>().mapArray(JSONString: jsonString) else {
            throw MappingError.unknownType
        }
        
        return array
    }
    
    /// Create models array from JSON string. Report error and return nil if unable.
    /// - parameter jsonString: String in JSON format to use for model creation.
    static func safeCreate(jsonString: String?, file: String = #file, function: String = #function, line: UInt = #line) -> Array? {
        do {
            return try create(jsonString: jsonString)
        } catch {
            RoutableLogger.logError("Unable to create array of objects from JSON string", error: error, data: ["jsonString": jsonString, "self": self], file: file, function: function, line: line)
            return nil
        }
    }
}

// ******************************* MARK: - [BaseMappable?] with data

public extension Array where Element: OptionalType, Element.Wrapped: BaseMappable {
    
    /// Creates models array from JSON string.
    /// - parameter jsonData: Data in JSON format to use for model creation.
    /// - throws: `MappingError.emptyData` if response data is empty.
    /// - throws: `MappingError.invalidJSON` if response isn't a valid JSON.
    /// - throws: `MappingError.unknownType` if it wasn't possible to create model.
    static func create(jsonData: Data?, file: String = #file, function: String = #function, line: UInt = #line) throws -> [Element] {
        guard let jsonData = jsonData, !jsonData.isEmpty else {
            throw MappingError.emptyData
        }
        
        // Start check
        guard jsonData.firstNonWhitespaceByte == ASCIICodes.openSquareBracket else {
            throw MappingError.invalidJSON(message: "JSON array should start with the '[' character")
        }
        
        // End check
        guard jsonData.lastNonWhitespaceByte == ASCIICodes.closeSquareBracket else {
            throw MappingError.invalidJSON(message: "JSON array should end with the ']' character")
        }
        
        guard let jsonObject = jsonData.safeSerializeToJSON(file: file, function: function, line: line) else {
            throw MappingError.invalidJSON(message: "Unable to serialize JSON array from the data")
        }
        
        guard let jsonArrayOfObjects = jsonObject as? [Any] else {
            throw MappingError.unknownType
        }
        
        return try jsonArrayOfObjects.map { object in
            if object is NSNull {
                return Element(nilLiteral: ())
                
            } else {
                if let _jsonObject = object as? [String: Any],
                   let jsonObject = Mapper<Element.Wrapped>().map(JSON: _jsonObject) as? Element {
                    
                    return jsonObject
                    
                } else {
                    throw MappingError.unknownType
                }
            }
        }
    }
    
    /// Create models array from JSON string. Report error and return nil if unable.
    /// - parameter jsonData: Data in JSON format to use for model creation.
    static func safeCreate(jsonData: Data?, file: String = #file, function: String = #function, line: UInt = #line) -> Array? {
        do {
            return try create(jsonData: jsonData)
        } catch {
            RoutableLogger.logError("Unable to create array of optional objects from JSON data", error: error, data: ["jsonData": jsonData?.asString], file: file, function: function, line: line)
            return nil
        }
    }
}

// ******************************* MARK: - [[BaseMappable]]

public extension RandomAccessCollection where Element: RandomAccessCollection, Element.Element: BaseMappable {
    
    /// Creates models array from JSON string.
    /// - parameter jsonString: String in JSON format to use for model creation.
    /// - throws: `TurvoError.emptyData` if response data is empty.
    /// - throws: `TurvoError.invalidJSON` if response isn't a valid JSON.
    /// - throws: `TurvoError.unknownType` if it wasn't possible to create model.
    static func create(jsonData: Data?, file: String = #file, function: String = #function, line: UInt = #line) throws -> [[Element.Element]] {
        guard let jsonData = jsonData else {
            throw MappingError.emptyData
        }
        
        guard !jsonData.isEmpty else {
            throw MappingError.emptyData
        }
        
        // Start check
        guard  jsonData.firstNonWhitespaceByte == ASCIICodes.openSquareBracket else {
            throw MappingError.invalidJSON(message: "JSON array of arrays should start with the '[' character")
        }
        
        guard jsonData.secondNonWhitespaceByte == ASCIICodes.openSquareBracket else {
            throw MappingError.invalidJSON(message: "JSON array should start with the '[' character")
        }
        
        // End check
        guard jsonData.lastNonWhitespaceByte == ASCIICodes.closeSquareBracket else {
            throw MappingError.invalidJSON(message: "JSON array of arrays should end with the ']' character")
        }
        
        guard jsonData.beforeLastNonWhitespaceByte == ASCIICodes.closeSquareBracket else {
            throw MappingError.invalidJSON(message: "JSON array should end with the ']' character")
        }
        
        guard let json = jsonData.safeSerializeToJSON(file: file, function: function, line: line) else {
            throw MappingError.invalidJSON(message: "Unable to serialize JSON array from the data")
        }
        
        guard let arrayOfArraysOfDictionaries = json as? [[[String: Any]]] else {
            throw MappingError.unknownType
        }
        
        guard let arrayOfArraysOfObjects = Mapper<Element.Element>().mapArrayOfArrays(JSONObject: arrayOfArraysOfDictionaries) else {
            throw MappingError.unknownType
        }
        
        return arrayOfArraysOfObjects
    }
    
    /// Create models array from JSON string. Report error and return nil if unable.
    /// - parameter jsonString: String in JSON format to use for model creation.
    static func safeCreate(jsonData: Data?, file: String = #file, function: String = #function, line: UInt = #line) -> [[Element.Element]]? {
        do {
            return try create(jsonData: jsonData)
        } catch {
            RoutableLogger.logError("Unable to create array of objects from JSON string", error: error, data: ["jsonData": jsonData, "self": self], file: file, function: function, line: line)
            return nil
        }
    }
    
    /// Creates models array from JSON string.
    /// - parameter jsonString: String in JSON format to use for model creation.
    /// - throws: `TurvoError.emptyData` if response data is empty.
    /// - throws: `TurvoError.invalidJSON` if response isn't a valid JSON.
    /// - throws: `TurvoError.unknownType` if it wasn't possible to create model.
    static func create(jsonString: String?, file: String = #file, function: String = #function, line: UInt = #line) throws -> [[Element.Element]] {
        guard let jsonString = jsonString else {
            throw MappingError.emptyData
        }
        
        guard !jsonString.isEmpty else {
            throw MappingError.emptyData
        }
        
        // Start check
        guard jsonString.firstNonWhitespaceCharacter == "[" else {
            throw MappingError.invalidJSON(message: "JSON array should start with the '[' character")
        }
        
        guard jsonString.secondNonWhitespaceCharacter == "[" else {
            throw MappingError.invalidJSON(message: "JSON array should start with the '[' character")
        }
        
        // End check
        guard jsonString.lastNonWhitespaceCharacter == "]" else {
            throw MappingError.invalidJSON(message: "JSON array of arrays should end with the ']' character")
        }
        
        guard jsonString.beforeLastNonWhitespaceCharacter == "]" else {
            throw MappingError.invalidJSON(message: "JSON array should end with the ']' character")
        }
        
        guard let arrayOfArraysOfDictionaries = Mapper<Element.Element>.parseJSONString(JSONString: jsonString) as? [[[String: Any]]] else {
            throw MappingError.unknownType
        }
        
        guard let arrayOfArraysOfObjects = Mapper<Element.Element>().mapArrayOfArrays(JSONObject: arrayOfArraysOfDictionaries) else {
            throw MappingError.unknownType
        }
        
        return arrayOfArraysOfObjects
    }
    
    /// Create models array from JSON string. Report error and return nil if unable.
    /// - parameter jsonString: String in JSON format to use for model creation.
    static func safeCreate(jsonString: String?, file: String = #file, function: String = #function, line: UInt = #line) -> [[Element.Element]]? {
        do {
            return try create(jsonString: jsonString)
        } catch {
            RoutableLogger.logError("Unable to create array of objects from JSON string", error: error, data: ["jsonString": jsonString, "self": self], file: file, function: function, line: line)
            return nil
        }
    }
}
