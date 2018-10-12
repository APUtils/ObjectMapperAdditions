//
//  RealmTransform.swift
//  ObjectMapperAdditions
//
//  Created by Anton Plebanovich on 7/25/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import RealmSwift
import ObjectMapper


/// Transforms Swift Arrays to Realm Arrays. E.g. [String] to List<String>.
public class RealmTransform<T: RealmCollectionValue>: TransformType {
    public typealias Object = List<T>
    public typealias JSON = [Any]
    
    public init() {}
    
    public func transformFromJSON(_ value: Any?) -> List<T>? {
        guard let array = value as? [Any] else { return nil }
        
        let list = List<T>()
        let realmValues: [T] = array.compactMap { $0 as? T }
        list.append(objectsIn: realmValues)
        
        return list
    }
    
    public func transformToJSON(_ value: List<T>?) -> [Any]? {
        guard let value = value else { return nil }
        
        return Array(value)
    }
}
