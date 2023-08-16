//
//  Realm+ObjectMapper.swift
//  Pods
//
//  Created by Anton Plebanovich on 23.02.23.
//  Copyright © 2023 Anton Plebanovich. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift
import RoutableLogger

public extension Object {
    
    /// `.toJSON()` requires Realm write transaction or it'll crash
    /// https://github.com/APUtils/ObjectMapperAdditions#realm-features
    func performMapping(file: String = #file, function: String = #function, line: UInt = #line, _ action: () -> Void) {
        guard !isInvalidated else {
            RoutableLogger.logError("Unable to perform mapping on the invalidated object", file: file, function: function, line: line)
            return
        }
        
        guard !isFrozen else {
            RoutableLogger.logError("Unable to perform mapping on the frozen object", file: file, function: function, line: line)
            return
        }
        
        let isWriteRequired = realm != nil && realm?.isInWriteTransaction == false
        if isWriteRequired { realm?.beginWrite() }
        action()
        if isWriteRequired { realm?.cancelWrite() }
    }
}

public extension EmbeddedObject {
    
    /// `.toJSON()` requires Realm write transaction or it'll crash
    /// https://github.com/APUtils/ObjectMapperAdditions#realm-features
    func performMapping(file: String = #file, function: String = #function, line: UInt = #line, _ action: () -> Void) {
        guard !isInvalidated else {
            RoutableLogger.logError("Unable to perform mapping on the invalidated object", file: file, function: function, line: line)
            return
        }
        
        guard !isFrozen else {
            RoutableLogger.logError("Unable to perform mapping on the frozen object", file: file, function: function, line: line)
            return
        }
        
        let isWriteRequired = realm != nil && realm?.isInWriteTransaction == false
        if isWriteRequired { realm?.beginWrite() }
        action()
        if isWriteRequired { realm?.cancelWrite() }
    }
}
