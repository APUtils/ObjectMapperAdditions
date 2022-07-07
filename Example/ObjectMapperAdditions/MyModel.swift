//
//  MyModel.swift
//  ObjectMapperAdditions
//
//  Created by Anton Plebanovich on 7/27/17.
//  Copyright © Anton Plebanovich. All rights reserved.
//

import Foundation
import ObjectMapper
import ObjectMapperAdditions


struct MyModel: Mappable {
    var string: String?
    var stringsArray: [String]?
    var double: Double?
    var myOtherModel: MyOtherModel?
    var myOtherModelsArray: [MyOtherModel]?
    var intEnum: ExampleIntEnum?
    var stringEnum: ExampleStringEnum?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        // You could specify proper type transform directly
        string <- (map["string"], StringTransform.shared)
        
        // Or you could just use TypeCastTransform
        string <- (map["string"], TypeCastTransform())
        
        // No doubt it also works with Double
        double <- (map["double"], TypeCastTransform())
        
        // Works with arrays too but for TypeCastTransform you must specify type
        stringsArray <- (map["stringsArray"], TypeCastTransform<String>())
        
        // Or just use StringTransform directly
        stringsArray <- (map["stringsArray"], StringTransform.shared)
        
        // No need to transform your types. They should specify transforms by themselfs.
        myOtherModel <- map["myOtherModel"]
        myOtherModelsArray <- map["myOtherModelsArray"]
        
        intEnum <- (map["intEnum"], EnumTypeCastTransform())
        stringEnum <- (map["stringEnum"], EnumTypeCastTransform())
    }
}

//-----------------------------------------------------------------------------
// MARK: - Equatable
//-----------------------------------------------------------------------------

extension MyModel: Equatable {
    static func ==(lhs: MyModel, rhs: MyModel) -> Bool {
        return lhs.string == rhs.string
            && lhs.stringsArray == rhs.stringsArray
            && lhs.double == rhs.double
            && lhs.myOtherModel == rhs.myOtherModel
            && lhs.myOtherModelsArray == rhs.myOtherModelsArray
    }
}
