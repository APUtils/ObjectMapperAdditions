//
//  String+Extension.swift
//  Pods
//
//  Created by Anton Plebanovich on 7.04.22.
//  Copyright © 2022 Anton Plebanovich. All rights reserved.
//

import Foundation

// ******************************* MARK: - Checks

private let kWhitespaceCharactersSet = CharacterSet(charactersIn: " \n\r")

extension String {
    
    var isNil: Bool {
        isEmpty || self == "-"
    }
    
    var firstNonWhitespaceCharacter: Character? {
        guard let index = firstIndex(where: { !kWhitespaceCharactersSet._containsUnicodeScalars(of: $0) }) else { return nil }
        return self[index]
    }
    
    var secondNonWhitespaceCharacter: Character? {
        guard let firstIndex = firstIndex(where: { !kWhitespaceCharactersSet._containsUnicodeScalars(of: $0) }) else { return nil }
                
        let secondIndex = index(after: firstIndex)
        guard secondIndex < endIndex else { return nil }
        
        return self[secondIndex]
    }
    
    var lastNonWhitespaceCharacter: Character? {
        guard let index = lastIndex(where: { !kWhitespaceCharactersSet._containsUnicodeScalars(of: $0) }) else { return nil }
        return self[index]
    }
    
    var beforeLastNonWhitespaceCharacter: Character? {
        guard let lastIndex = lastIndex(where: { !kWhitespaceCharactersSet._containsUnicodeScalars(of: $0) }) else { return nil }
        
        let beforeLastIndex = index(before: lastIndex)
        guard startIndex <= beforeLastIndex else { return nil }
        
        return self[beforeLastIndex]
    }
}


// ******************************* MARK: - Other

extension String {
    
    /// Returns fileName without extension
    var _fileName: String {
        guard let lastPathComponent = components(separatedBy: "/").last else { return "" }
        
        var components = lastPathComponent.components(separatedBy: ".")
        if components.count == 1 {
            return lastPathComponent
        } else {
            components.removeLast()
            return components.joined(separator: ".")
        }
    }
}

extension CharacterSet {
    func _containsUnicodeScalars(of character: Character) -> Bool {
        return character.unicodeScalars.allSatisfy(contains(_:))
    }
}
