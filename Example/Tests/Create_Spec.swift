//
//  Create_Spec.swift
//  ObjectMapperAdditions
//
//  Created by Anton Plebanovich on 12.01.22.
//  Copyright © 2022 Anton Plebanovich. All rights reserved.
//

import Quick
import Nimble
import ObjectMapper
import ObjectMapperAdditions
import APExtensions
@testable import ObjectMapperAdditions_Example

class Create_Spec: QuickSpec {
    override func spec() {
        describe("Create") {
            
            let jsonObjectData = try! JSONSerialization.data(withJSONObject: ["string":"string"])
            let jsonObjectString = jsonObjectData.safeUTF8String()
            
            let jsonArrayData = try! JSONSerialization.data(withJSONObject: [["string":"string"]])
            let jsonArrayString = jsonArrayData.safeUTF8String()
            
            let jsonArrayOfArraysData = try! JSONSerialization.data(withJSONObject: [[["string":"string"]]])
            let jsonArrayOfArraysString = jsonArrayOfArraysData.safeUTF8String()
            
            describe("[BaseMappable]") {
                it("should map from JSON") {
                    expect(try [MappableStruct].create(jsonData: jsonArrayData)).toNot(throwError())
                    expect([MappableStruct].safeCreate(jsonData: jsonArrayData)).toNot(beNil())
                    
                    expect(try [MappableStruct].create(jsonString: jsonArrayString)).toNot(throwError())
                    expect([MappableStruct].safeCreate(jsonString: jsonArrayString)).toNot(beNil())
                }
            }
            
            describe("[BaseMappable?]") {
                it("should map from JSON") {
                    expect(try [MappableStruct?].create(jsonData: jsonArrayData)).toNot(throwError())
                    expect([MappableStruct?].safeCreate(jsonData: jsonArrayData)).toNot(beNil())
                }
            }
            
            describe("[[BaseMappable]]") {
                it("should map from JSON") {
                    expect(try [[MappableStruct]].create(jsonData: jsonArrayOfArraysData)).toNot(throwError())
                    expect([[MappableStruct]].safeCreate(jsonData: jsonArrayOfArraysData)).toNot(beNil())
                    
                    expect(try [[MappableStruct]].create(jsonString: jsonArrayOfArraysString)).toNot(throwError())
                    expect([[MappableStruct]].safeCreate(jsonString: jsonArrayOfArraysString)).toNot(beNil())
                }
            }
            
            describe("Mappable") {
                it("should map from JSON object") {
                    expect(try MappableStruct.create(jsonData: jsonObjectData)).toNot(throwError())
                    expect(MappableStruct.safeCreate(jsonData: jsonObjectData)).toNot(beNil())
                    
                    expect(try MappableStruct.create(jsonString: jsonObjectString)).toNot(throwError())
                    expect(MappableStruct.safeCreate(jsonString: jsonObjectString)).toNot(beNil())
                }
            }
            
            describe("ImmutableMappable") {
                it("should map from JSON object") {
                    expect(try ImmutableMappableStruct.create(jsonData: jsonObjectData)).toNot(throwError())
                    expect(ImmutableMappableStruct.safeCreate(jsonData: jsonObjectData)).toNot(beNil())
                    
                    expect(try ImmutableMappableStruct.create(jsonString: jsonObjectString)).toNot(throwError())
                    expect(ImmutableMappableStruct.safeCreate(jsonString: jsonObjectString)).toNot(beNil())
                }
            }
        }
    }
}

private struct MappableStruct: Mappable {
    var string: String?
    init?(map: Map) {}
    mutating func mapping(map: ObjectMapper.Map) {
        string <- map["string"]
    }
}

private struct ImmutableMappableStruct: ImmutableMappable {
    let string: String
    init(map: Map) throws {
        string = try map.value("string")
    }
}
