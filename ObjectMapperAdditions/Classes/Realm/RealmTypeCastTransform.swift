//
//  RealmTypeCastTransform.swift
//  ObjectMapperAdditions
//
//  Created by Anton Plebanovich on 7/27/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import RealmSwift
import ObjectMapper

#if !COCOAPODS
    import ObjectMapperAdditions
#endif


/// Transforms Swift Arrays to Realm Arrays. E.g. [String] to List<String>.
/// Additionally, it will type cast value if type mismatches. E.g. "123" String to 123 Int.
public class RealmTypeCastTransform<T: RealmCollectionValue>: TransformType {
    public typealias Object = List<T>
    public typealias JSON = [Any]
    
    public init() {}
    
    public func transformFromJSON(_ value: Any?) -> Object? {
        guard let array = value as? [Any] else { return nil }
        
        let typeCastTransform = TypeCastTransform<T>()
        let realmValues: [T] = array.compactMap { typeCastTransform.transformFromJSON($0) }
        
        let list = List<T>()
        list.append(objectsIn: realmValues)
        
        return list
    }
    
    public func transformToJSON(_ value: Object?) -> JSON? {
        guard let value = value else { return nil }
        
        return Array(value)
    }
}
