//
//  MyPersistedRealmModel.swift
//  ObjectMapperAdditions
//
//  Created by Anton Plebanovich on 12.04.24.
//  Copyright © 2024 Anton Plebanovich. All rights reserved.
//

import Foundation
import ObjectMapper
import ObjectMapperAdditions
import RealmSwift

class MyPersistedRealmModel: Object, Mappable {
    @Persisted var id: Int = 0
    @Persisted var double: Double = 0
    @Persisted var optionalDouble: Double?
    @Persisted var string: String?
    @Persisted var myOtherRealmModel: MyOtherRealmModel?
    @Persisted var myOtherRealmModels: List<MyOtherRealmModel>
    @Persisted var myRealmMap: RealmSwift.Map<String, String>
    @Persisted var strings: List<String>
    
    override class func primaryKey() -> String? { "id" }
    
    override init() {
        super.init()
    }
    
    required init?(map: ObjectMapper.Map) {
        super.init()
        
        // Primary kay should not be reassigned after object is added to the Realm so we make sure it is assigned during init only
        id <- (map["id"], IntTransform.shared)
    }
    
    func mapping(map: ObjectMapper.Map) {
        performMapping {
            // Read-only primary key
            id >>> map["id"]
            
            // Same as for ordinary model
            double <- (map["double"], DoubleTransform.shared)
            
            // Using ObjectMapperAdditions's RealmPropertyTypeCastTransform
            optionalDouble <- (map["optionalDouble"], DoubleTransform.shared)
            
            // Custom transform support
//            optionalDouble <- (map["optionalDouble"], DoubleTransform.shared)
            
            // You could also use RealmPropertyTransform if you don't like type cast but you need to declare `optionalDouble` as a `var` then
//            optionalDouble <- (map["optionalDouble"], RealmPropertyTransform<Double>())
            
            string <- (map["string"], StringTransform.shared)
            myOtherRealmModel <- map["myOtherRealmModel"]
            
            // Using ObjectMapper+Realm's RealmListTransform to transform custom types
            myOtherRealmModels <- map["myOtherRealmModels"]

            // For some reason, Xcode 15.3 can't properly select proper operator so we need a workaround
            let myRealmMap = self.myRealmMap
            myRealmMap <- map["myRealmMap"]
            
            // Using ObjectMapperAdditions's RealmTypeCastTransform
            strings <- map["strings"]
            
            // // Custom transform support
//            strings <- (map["strings"], StringTransform.shared)
            
            // You could also use RealmTransform if you don't like type cast but you need to declare `optionalDouble` as a `var` then
//            strings <- (map["strings"], RealmTransform())
        }
    }
}
