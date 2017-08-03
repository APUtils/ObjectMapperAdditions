//
//  RealmTypeCastTransform.swift
//  ObjectMapperAdditions
//
//  Created by Anton Plebanovich on 7/27/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import RealmSwift
import RealmAdditions
import ObjectMapper


/// Transforms Swift Arrays to Realm Arrays. E.g. [String] to List<RealmString>.
/// It supports Int, Double, Bool and String types.
/// Additionally, it will type cast value if type mismatches. E.g. "123" String to 123 Int.
public class RealmTypeCastTransform<T: Object>: TransformType where T: RealmValue {
    public typealias Object = List<T>
    public typealias JSON = [Any]
    
    public init() {}
    
    public func transformFromJSON(_ value: Any?) -> Object? {
        guard let array = value as? [Any] else { return nil }
        
        let realmValues: [T] = array.flatMap({
            guard let value = TypeCastTransform<T.ValueType>().transformFromJSON($0) else { return nil }
            
            let realmValue = T()
            realmValue.value = value
            
            return realmValue
        })
        
        let list = List<T>()
        list.append(objectsIn: realmValues)
        
        return list
    }
    
    public func transformToJSON(_ value: Object?) -> JSON? {
        guard let value = value else { return nil }
        
        return value.map({ $0.value })
    }
}
