//
//  RealmPropertyTransform.swift
//  Pods
//
//  Created by Anton Plebanovich on 7.11.21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import RealmSwift
import ObjectMapper

/// Transforms Swift numeric to `RealmProperty<T>`.
/// E.g. Int? to RealmOptional<Int?> or Double to RealmOptional<Int>.
public class RealmPropertyTransform<T: RealmOptionalType & _RealmSchemaDiscoverable>: TransformType {
    public typealias Object = RealmProperty<T?>
    public typealias JSON = Any
    
    public init() {}
    
    public func transformFromJSON(_ value: Any?) -> RealmProperty<T?>? {
        let realmProperty = RealmProperty<T?>()
        guard let value = value as? T else { return realmProperty }
        
        realmProperty.value = value
        
        return realmProperty
    }
    
    public func transformToJSON(_ value: RealmProperty<T?>?) -> Any? {
        return value?.value
    }
}
