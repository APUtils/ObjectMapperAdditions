//
//  MyModel.swift
//  ObjectMapperAdditions
//
//  Created by Anton Plebanovich on 7/27/17.
//  Copyright © Anton Plebanovich. All rights reserved.
//

import Foundation
import APExtensions
import ObjectMapper
import ObjectMapperAdditions


public struct MyModel: Mappable {
    public var string: String?
    public var stringsArray: [String]?
    public var double: Double?
    public var myOtherModel: MyOtherModel?
    public var myOtherModelsArray: [MyOtherModel]?
    
    public init?(map: Map) {}
    
    public mutating func mapping(map: Map) {
        // You could specify proper type transform directly
        string <- (map["string"], StringTransform())
        
        // Or you could just use TypeCastTransform
        string <- (map["string"], TypeCastTransform())
        
        // No doubt it also works with Double
        double <- (map["double"], TypeCastTransform())
        
        // Works with arrays too but for TypeCastTransform you must specify type
        stringsArray <- (map["stringsArray"], TypeCastTransform<String>())
        
        // Or just use StringTransform directly
        stringsArray <- (map["stringsArray"], StringTransform())
        
        // No need to transform your types. They should specify transforms by themselfs.
        myOtherModel <- map["myOtherModel"]
        myOtherModelsArray <- map["myOtherModelsArray"]
    }
}

//-----------------------------------------------------------------------------
// MARK: - Equatable
//-----------------------------------------------------------------------------

extension MyModel: Equatable {
    public static func ==(lhs: MyModel, rhs: MyModel) -> Bool {
        return lhs.string == rhs.string
            && lhs.stringsArray == rhs.stringsArray
            && lhs.double == rhs.double
            && lhs.myOtherModel == rhs.myOtherModel
            && lhs.myOtherModelsArray == rhs.myOtherModelsArray
    }
}
