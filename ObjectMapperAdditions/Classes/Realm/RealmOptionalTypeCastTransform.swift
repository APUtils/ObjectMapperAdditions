//
//  RealmOptionalTypeCastTransform.swift
//  ObjectMapperAdditions
//
//  Created by Anton Plebanovich on 3/27/18.
//  Copyright © 2018 Anton Plebanovich. All rights reserved.
//

import RealmSwift
import ObjectMapper

#if !COCOAPODS
    import ObjectMapperAdditions
#endif


/// Transforms Swift numeric Optional to Realm numberic Optional. E.g. Int? to RealmOptional<Int>.
/// Additionally, it will type cast value if type mismatches. E.g. "123" String to 123 Int.
public class RealmOptionalTypeCastTransform<T: RealmOptionalType>: TransformType {
    public typealias Object = RealmOptional<T>
    public typealias JSON = Any
    
    public init() {}
    
    public func transformFromJSON(_ value: Any?) -> RealmOptional<T>? {
        let typeCastTransform = TypeCastTransform<T>()
        let castedValue = typeCastTransform.transformFromJSON(value)
        let realmOptional = RealmOptional<T>(castedValue)
        
        return realmOptional
    }
    
    public func transformToJSON(_ value: Object?) -> Any? {
        return value?.value
    }
}
