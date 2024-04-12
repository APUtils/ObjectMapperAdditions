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
#if !COCOAPODS
import ObjectMapperAdditions
#endif

// ******************************* MARK: - List

public func <- <T: RealmCollectionValue & Mappable>(left: List<T>, right: ObjectMapper.Map) {
    if right.mappingType == .toJSON {
        Array(left) >>> right
        
    } else if right.mappingType == .fromJSON {
        if right.isKeyPresent {
            var objects: [T]?
            objects <- right
            
            if let objects {
                if !left.isEmpty {
                    left.removeAll()
                }
                left.append(objectsIn: objects)
                
            } else {
                left.removeAll()
            }
        }
    }
}

public func <- <T: RealmCollectionValue>(left: List<T>, right: ObjectMapper.Map) {
    if right.mappingType == .toJSON {
        Array(left) >>> right
        
    } else if right.mappingType == .fromJSON {
        if right.isKeyPresent {
            var objects: [T]?
            objects <- (right, TypeCastTransform<T>())
            
            if let objects {
                if !left.isEmpty {
                    left.removeAll()
                }
                left.append(objectsIn: objects)
                
            } else {
                left.removeAll()
            }
        }
    }
}

public func <- <T: RealmCollectionValue, Transform: TransformType>(left: List<T>, right: (ObjectMapper.Map, Transform)) where T == Transform.Object {
    let map = right.0
    if map.mappingType == .toJSON {
        Array(left) >>> right
        
    } else if map.mappingType == .fromJSON {
        if map.isKeyPresent {
            var objects: [T]?
            objects <- right
            
            if let objects {
                if !left.isEmpty {
                    left.removeAll()
                }
                left.append(objectsIn: objects)
                
            } else {
                left.removeAll()
            }
        }
    }
}

// ******************************* MARK: - Map

/// Old sytax with `let`
public func <- <Key: _MapKey, Value: RealmCollectionValue>(left: RealmSwift.Map<Key, Value>, right: ObjectMapper.Map) {
    if right.mappingType == .toJSON {
        let dictionary = left.reduce(into: [Key: Value]()) { dictionary, tuple in
            dictionary[tuple.key] = tuple.value
        }
        
        dictionary >>> right
        
    } else if right.mappingType == .fromJSON {
        if right.isKeyPresent {
            var keyValues: [Key: Value]?
            keyValues <- right
            
            if let keyValues {
                if left.count > 0 {
                    left.removeAll()
                }
                for keyValue in keyValues {
                    left[keyValue.key] = keyValue.value
                }
                
            } else {
                left.removeAll()
            }
        }
    }
}

// ******************************* MARK: - RealmProperty

public func <- <T: RealmCollectionValue>(left: RealmProperty<T?>, right: ObjectMapper.Map) {
    if right.mappingType == .toJSON {
        left.value >>> right
        
    } else if right.mappingType == .fromJSON {
        if right.isKeyPresent {
            var value: T?
            value <- (right, TypeCastTransform<T>())
            left.value = value
        }
    }
}

public func <- <T: RealmCollectionValue, Transform: TransformType>(left: RealmProperty<T?>, right: (ObjectMapper.Map, Transform)) where T == Transform.Object {
    let map = right.0
    let transform = right.1
    if map.mappingType == .toJSON {
        left.value >>> map
        
    } else if map.mappingType == .fromJSON {
        if map.isKeyPresent {
            let value = transform.transformFromJSON(map.currentValue)
            left.value = value
        }
    }
}
