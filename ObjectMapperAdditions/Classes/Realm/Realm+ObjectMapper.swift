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

public extension Object {
    
    /// `.toJSON()` requires Realm write transaction or it'll crash
    /// https://github.com/APUtils/ObjectMapperAdditions#realm-features
    func performMapping(_ action: () -> Void) {
        let isWriteRequired = realm != nil && realm?.isInWriteTransaction == false
        if isWriteRequired { realm?.beginWrite() }
        action()
        if isWriteRequired { realm?.cancelWrite() }
    }
}
