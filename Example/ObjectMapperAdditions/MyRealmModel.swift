//
//  MyRealmModel.swift
//  <#PROJECT_NAME#>
//
//  Created by mac-246 on 07/27/17.
//  Copyright © 2017 mac-246. All rights reserved.
//

import Foundation
import ObjectMapper
import ObjectMapperAdditions
import ObjectMapper_Realm
import RealmSwift
import RealmAdditions


public class MyRealmModel: Object, Mappable {
    public dynamic var double: Double = 0
    public dynamic var string: String?
    public dynamic var myOtherRealmModel: MyOtherRealmModel?
    
    // Please take a note it's `var` and is not optional
    public var myOtherRealmModels: List<MyOtherRealmModel> = List<MyOtherRealmModel>()
    
    // Strings array will be casted to List<RealmString>
    public var strings: List<RealmString> = List<RealmString>()
    
    // You could add computed property to simplify set and get:
    public var _strings: [String] {
        get {
            return strings.map({ $0.value })
        }
        set {
            strings.removeAll()
            strings.append(objectsIn: newValue.map(RealmString.init(swiftValue:)))
        }
    }
    
    // Do not forget to ignore our helper property
    public override static func ignoredProperties() -> [String] {
        return ["_strings"]
    }

    public required convenience init?(map: Map) { self.init() }

    public func mapping(map: Map) {
        // .toJSON() requires Realm write transaction or it'll crash
        let isWriteRequired = realm != nil && realm?.isInWriteTransaction == false
        isWriteRequired ? realm?.beginWrite() : ()

        // Same as for ordinary model
        double <- (map["double"], DoubleTransform())
        string <- (map["string"], StringTransform())
        myOtherRealmModel <- map["myOtherRealmModel"]
        
        // Using ObjectMapper+Realm's ListTransform to transform custom types
        myOtherRealmModels <- (map["myOtherRealmModels"], ListTransform<MyOtherRealmModel>())
        
        // Using ObjectMapperAdditions's RealmTypeCastTransform
        strings <- (map["strings"], RealmTypeCastTransform<RealmString>())
        
        // You could also use RealmTransform if you don't like type cast
//        strings <- (map["strings"], RealmTransform<RealmString>())

        isWriteRequired ? try? realm?.commitWrite() : ()
    }
}
