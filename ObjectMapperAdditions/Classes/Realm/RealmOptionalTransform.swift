//
//  RealmOptionalTransform.swift
//  ObjectMapperAdditions
//
//  Created by Anton Plebanovich on 3/26/18.
//  Copyright © 2018 Anton Plebanovich. All rights reserved.
//

import RealmSwift
import ObjectMapper


/// Transforms Swift numeric Optional to Realm numberic Optional. E.g. Int? to RealmOptional<Int>.
@available(*, deprecated, renamed: "RealmPropertyTransform", message: "RealmOptionalTransform<T> and RealmOptional<T> has been deprecated, use RealmPropertyTransform<T> and RealmProperty<T?> instead.")
public class RealmOptionalTransform<T: RealmOptionalType>: TransformType {
    public typealias Object = RealmOptional<T>
    public typealias JSON = Any
    
    public init() {}
    
    public func transformFromJSON(_ value: Any?) -> RealmOptional<T>? {
        guard let value = value as? T else { return nil }
        
        let realmOptional = RealmOptional<T>(value)
        
        return realmOptional
    }
    
    public func transformToJSON(_ value: RealmOptional<T>?) -> Any? {
        return value?.value
    }
}
