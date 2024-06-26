//
//  MyRealmModel.swift
//  ObjectMapperAdditions
//
//  Created by mac-246 on 07/27/17.
//  Copyright © 2017 mac-246. All rights reserved.
//

import Foundation
import ObjectMapper
import ObjectMapperAdditions
import RealmSwift

class MyRealmModel: Object, Mappable {
    @objc dynamic var id: Int = 0
    @objc dynamic var double: Double = 0
    let optionalDouble = RealmProperty<Double?>()
    @objc dynamic var string: String?
    @objc dynamic var myOtherRealmModel: MyOtherRealmModel?
    let myOtherRealmModels = List<MyOtherRealmModel>()
    let myRealmMap = RealmSwift.Map<String, String>()
    var strings: List<String> = List<String>()
    
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
            optionalDouble <- map["optionalDouble"]
            
            // Custom transform support
//            optionalDouble <- (map["optionalDouble"], DoubleTransform.shared)
            
            // You could also use RealmPropertyTransform if you don't like type cast but you need to declare `optionalDouble` as a `var` then
//            optionalDouble <- (map["optionalDouble"], RealmPropertyTransform<Double>())
            
            string <- (map["string"], StringTransform.shared)
            myOtherRealmModel <- map["myOtherRealmModel"]
            
            // Using ObjectMapper+Realm's RealmListTransform to transform custom types
            myOtherRealmModels <- map["myOtherRealmModels"]
            
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
