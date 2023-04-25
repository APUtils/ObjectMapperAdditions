//
//  RealmPropertyTypeCastTransform.swift
//  Pods
//
//  Created by Anton Plebanovich on 7.11.21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import RealmSwift
import ObjectMapper
#if !COCOAPODS
import ObjectMapperAdditions
#endif

/// Transforms Swift numeric to `RealmProperty<T>`.
/// E.g. Int? to RealmOptional<Int?>.
/// Additionally, it will type cast value if type mismatches. E.g. "123" String to 123 Int.
public class RealmPropertyTypeCastTransform<T: RealmOptionalType & _RealmSchemaDiscoverable>: TransformType {
    public typealias Object = RealmProperty<T?>
    public typealias JSON = Any
    
    public init() {}
    
    public func transformFromJSON(_ value: Any?) -> RealmProperty<T?>? {
        let realmOptional = RealmProperty<T?>()
        let typeCastTransform = TypeCastTransform<T>()
        guard let castedValue = typeCastTransform.transformFromJSON(value) else { return realmOptional }
        realmOptional.value = castedValue
        
        return realmOptional
    }
    
    public func transformToJSON(_ value: RealmProperty<T?>?) -> Any? {
        return value?.value
    }
}
