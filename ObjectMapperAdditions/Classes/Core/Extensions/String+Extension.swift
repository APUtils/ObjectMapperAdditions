//
//  String+Extension.swift
//  Pods
//
//  Created by Anton Plebanovich on 7.04.22.
//  Copyright © 2022 Anton Plebanovich. All rights reserved.
//

// ******************************* MARK: - Checks

private let kSpaceCharacter = Character(" ")
private let kNewLineCharacter = Character("\n")

extension String {
    
    var isNil: Bool {
        isEmpty || self == "-"
    }
    
    var firstNonWhitespaceCharacter: Character? {
        guard let index = firstIndex(where: { $0 != kSpaceCharacter && $0 != kNewLineCharacter }) else { return nil }
        return self[index]
    }
    
    var secondNonWhitespaceCharacter: Character? {
        guard let firstIndex = firstIndex(where: { $0 != kSpaceCharacter && $0 != kNewLineCharacter }) else { return nil }
                
        let secondIndex = index(after: firstIndex)
        guard secondIndex < endIndex else { return nil }
        
        return self[secondIndex]
    }
    
    var lastNonWhitespaceCharacter: Character? {
        guard let index = lastIndex(where: { $0 != kSpaceCharacter && $0 != kNewLineCharacter }) else { return nil }
        return self[index]
    }
    
    var beforeLastNonWhitespaceCharacter: Character? {
        guard let lastIndex = lastIndex(where: { $0 != kSpaceCharacter && $0 != kNewLineCharacter }) else { return nil }
        
        let beforeLastIndex = index(before: lastIndex)
        guard startIndex <= beforeLastIndex else { return nil }
        
        return self[beforeLastIndex]
    }
}
