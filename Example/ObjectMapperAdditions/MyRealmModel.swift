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
    var strings: List<String> = List<String>()
    
    override class func primaryKey() -> String? { "id" }

    required convenience init?(map: ObjectMapper.Map) {
        self.init()
        
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
            // You could also use RealmPropertyTransform if you don't like type cast
//            optionalDouble <- (map["optionalDouble"], RealmPropertyTransform<Double>())
            
            string <- (map["string"], StringTransform.shared)
            myOtherRealmModel <- map["myOtherRealmModel"]
            
            // Using ObjectMapper+Realm's RealmListTransform to transform custom types
            myOtherRealmModels <- map["myOtherRealmModels"]
            
            // Using ObjectMapperAdditions's RealmTypeCastTransform
            strings <- map["strings"]
            // You could also use RealmTransform if you don't like type cast
//            strings <- (map["strings"], RealmTransform())
        }
    }
}
