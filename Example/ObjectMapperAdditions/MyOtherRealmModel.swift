//
//  MyOtherRealmModel.swift
//  ObjectMapperAdditions
//
//  Created by mac-246 on 07/27/17.
//  Copyright © 2017 mac-246. All rights reserved.
//

import Foundation
import ObjectMapper
import ObjectMapperAdditions
import ObjectMapper_Realm
import RealmSwift


public class MyOtherRealmModel: Object, Mappable {
    public required convenience init?(map: Map) { self.init() }
    public func mapping(map: Map) {}
}
