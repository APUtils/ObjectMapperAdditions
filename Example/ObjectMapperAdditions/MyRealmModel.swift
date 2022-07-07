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
    @objc dynamic var double: Double = 0
    
    // Please take a note it's `var` and is not optional
    // However new value should be assigned through `.value`
    var optionalDouble = RealmProperty<Double?>()
    
    @objc dynamic var string: String?
    @objc dynamic var myOtherRealmModel: MyOtherRealmModel?
    
    // Please take a note it's `var` and is not optional
    // However, new value should be assigned through `.append(_:)`
    var myOtherRealmModels = List<MyOtherRealmModel>()
    
    // Strings array will be casted to List<RealmString>
    var strings: List<String> = List<String>()

    required convenience init?(map: ObjectMapper.Map) { self.init() }

    func mapping(map: ObjectMapper.Map) {
        // .toJSON() requires Realm write transaction or it'll crash
        let isWriteRequired = realm != nil && realm?.isInWriteTransaction == false
        isWriteRequired ? realm?.beginWrite() : ()

        // Same as for ordinary model
        double <- (map["double"], DoubleTransform.shared)
        
        // Using ObjectMapperAdditions's RealmPropertyTypeCastTransform
        optionalDouble <- (map["optionalDouble"], RealmPropertyTypeCastTransform())
        // You could also use RealmPropertyTransform if you don't like type cast
//        optionalDouble <- (map["optionalDouble"], RealmPropertyTransform<Double>())
        
        string <- (map["string"], StringTransform.shared)
        myOtherRealmModel <- map["myOtherRealmModel"]
        
        // Using ObjectMapper+Realm's RealmListTransform to transform custom types
        myOtherRealmModels <- (map["myOtherRealmModels"], RealmListTransform<MyOtherRealmModel>())
        
        // Using ObjectMapperAdditions's RealmTypeCastTransform
        strings <- (map["strings"], RealmTypeCastTransform())
        // You could also use RealmTransform if you don't like type cast
//        strings <- (map["strings"], RealmTransform())
        
        isWriteRequired ? try? realm?.commitWrite() : ()
    }
}
