//
//  ObjectMapper+Realm.swift
//  Pods
//
//  Created by Anton Plebanovich on 23.02.23.
//  Copyright © 2023 Anton Plebanovich. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

public func <- <T: RealmCollectionValue & Mappable>(left: List<T>, right: ObjectMapper.Map) {
    if right.mappingType == .toJSON {
        Array(left) >>> right
        
    } else if right.mappingType == .fromJSON {
        var objects: [T]?
        objects <- right
        
        if let objects {
            left.append(objectsIn: objects)
        } else {
            left.removeAll()
        }
    }
}

public func <- <T: RealmCollectionValue>(left: List<T>, right: ObjectMapper.Map) {
    if right.mappingType == .toJSON {
        Array(left) >>> right
        
    } else if right.mappingType == .fromJSON {
        var objects: [T]?
        objects <- (right, TypeCastTransform<T>())
        
        if let objects {
            left.append(objectsIn: objects)
        } else {
            left.removeAll()
        }
    }
}

public func <- <T: RealmCollectionValue>(left: RealmProperty<T?>, right: ObjectMapper.Map) {
    if right.mappingType == .toJSON {
        left.value >>> right
        
    } else if right.mappingType == .fromJSON {
        var value: T?
        value <- (right, TypeCastTransform<T>())
        left.value = value
    }
}
