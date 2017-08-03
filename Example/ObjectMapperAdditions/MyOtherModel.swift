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


public struct MyOtherModel: Mappable {
    public init?(map: Map) {}
    public mutating func mapping(map: Map) {}
}

//-----------------------------------------------------------------------------
// MARK: - Equatable
//-----------------------------------------------------------------------------

extension MyOtherModel: Equatable {
    public static func ==(lhs: MyOtherModel, rhs: MyOtherModel) -> Bool {
        return true
    }
}
