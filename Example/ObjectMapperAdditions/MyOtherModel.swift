//
//  MyOtherModel.swift
//  ObjectMapperAdditions
//
//  Created by Anton Plebanovich on 7/27/17.
//  Copyright © Anton Plebanovich. All rights reserved.
//

import Foundation
import ObjectMapper
import ObjectMapperAdditions


struct MyOtherModel: Mappable {
    init?(map: Map) {}
    mutating func mapping(map: Map) {}
}

//-----------------------------------------------------------------------------
// MARK: - Equatable
//-----------------------------------------------------------------------------

extension MyOtherModel: Equatable {
    static func ==(lhs: MyOtherModel, rhs: MyOtherModel) -> Bool {
        return true
    }
}
