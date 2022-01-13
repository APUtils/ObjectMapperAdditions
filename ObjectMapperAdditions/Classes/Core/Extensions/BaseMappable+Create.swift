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
        if jsonData.first == ASCIICodes.space || jsonData.first == ASCIICodes.newLine {
            RoutableLogger.logWarning("JSON data starts with a white space. That's weird.")
            
        } else {
            guard jsonData.first == ASCIICodes.openSquareBracket else {
                throw MappingError.invalidJSON(message: "JSON array should start with the '[' character")
            }
        }
        
        // End check
        if jsonData.last == ASCIICodes.space || jsonData.last == ASCIICodes.newLine {
            RoutableLogger.logWarning("JSON data ends with a white space. That's weird.")
            
        } else {
            guard jsonData.last == ASCIICodes.closeSquareBracket else {
                throw MappingError.invalidJSON(message: "JSON array should end with the ']' character")
            }
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
        if jsonString.first == " " || jsonString.first == "\n" {
            RoutableLogger.logWarning("JSON string starts with a white space. That's weird.")
            
        } else {
            guard jsonString.first == "[" else {
                throw MappingError.invalidJSON(message: "JSON array should start with the '[' character")
            }
        }
        
        // End check
        if jsonString.last == " " || jsonString.last == "\n" {
            RoutableLogger.logWarning("JSON string ends with a white space. That's weird.")
            
        } else {
            guard jsonString.last == "]" else {
                throw MappingError.invalidJSON(message: "JSON array should end with the ']' character")
            }
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
        if jsonData.first == ASCIICodes.space || jsonData.first == ASCIICodes.newLine {
            RoutableLogger.logWarning("JSON data starts with a white space. That's weird.")
            
        } else {
            guard jsonData.first == ASCIICodes.openSquareBracket else {
                throw MappingError.invalidJSON(message: "JSON array should start with the '[' character")
            }
        }
        
        // End check
        if jsonData.last == ASCIICodes.space || jsonData.last == ASCIICodes.newLine {
            RoutableLogger.logWarning("JSON data ends with a white space. That's weird.")
            
        } else {
            guard jsonData.last == ASCIICodes.closeSquareBracket else {
                throw MappingError.invalidJSON(message: "JSON array should end with the ']' character")
            }
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
        if jsonData.first == ASCIICodes.space || jsonData.first == ASCIICodes.newLine {
            RoutableLogger.logWarning("JSON data starts with a white space. That's weird.")
            
        } else {
            guard  jsonData.first == ASCIICodes.openSquareBracket else {
                throw MappingError.invalidJSON(message: "JSON array of arrays should start with the '[' character")
            }
            
            guard jsonData.count >= 2, jsonData[1] == ASCIICodes.openSquareBracket else {
                throw MappingError.invalidJSON(message: "JSON array should start with the '[' character")
            }
        }
        
        // End check
        if jsonData.last == ASCIICodes.space || jsonData.last == ASCIICodes.newLine {
            RoutableLogger.logWarning("JSON data ends with a white space. That's weird.")
            
        } else {
            guard jsonData.last == ASCIICodes.closeSquareBracket else {
                throw MappingError.invalidJSON(message: "JSON array of arrays should end with the ']' character")
            }
            
            guard jsonData.count >= 4, jsonData[jsonData.count - 2] == ASCIICodes.closeSquareBracket else {
                throw MappingError.invalidJSON(message: "JSON array should end with the ']' character")
            }
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
        if jsonString.first == " " || jsonString.first == "\n" {
            RoutableLogger.logWarning("JSON string starts with a white space. That's weird.")
            
        } else {
            guard jsonString.first == "[" else {
                throw MappingError.invalidJSON(message: "JSON array should start with the '[' character")
            }
            
            guard jsonString.count >= 2, jsonString[jsonString.index(jsonString.startIndex, offsetBy: 1)] == "[" else {
                throw MappingError.invalidJSON(message: "JSON array should start with the '[' character")
            }
        }
        
        // End check
        if jsonString.last == " " || jsonString.last == "\n" {
            RoutableLogger.logWarning("JSON string ends with a white space. That's weird.")
        
        } else {
            guard jsonString.last == "]" else {
                throw MappingError.invalidJSON(message: "JSON array of arrays should end with the ']' character")
            }
            
            guard jsonString.count >= 4, jsonString[jsonString.index(jsonString.endIndex, offsetBy: -2)] == "]" else {
                throw MappingError.invalidJSON(message: "JSON array should end with the ']' character")
            }
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
