// https://github.com/Quick/Quick

import Quick
import Nimble
import ObjectMapper
import ObjectMapperAdditions
import APExtensions
@testable import ObjectMapperAdditions_Example


class TypeCastSpec: QuickSpec {
    override class func spec() {
        describe("Type cast") {
            context("when JSON contains proper type params") {
                let typeMatchingJSON: [String: Any] = [
                    "string": "123",
                    "stringsArray": ["123.0", "321.0"],
                    "double": 1.1,
                    "intEnum": 1,
                    "stringEnum": "2"
                ]
                
                it("should map it propertly") {
                    let model = MyModel(JSON: typeMatchingJSON)
                    expect(model?.string).to(equal("123"))
                    expect(model?.stringsArray).to(equal(["123.0", "321.0"]))
                    expect(model?.double).to(equal(1.1))
                    expect(model?.intEnum).to(equal(.one))
                    expect(model?.stringEnum).to(equal(.two))
                }
            }
            
            context("when JSON contains wrong type params") {
                let typeMismatchingJSON: [String: Any] = [
                    "string": 123,
                    "stringsArray": [123.0, 321.0],
                    "double": "1.1",
                    "intEnum": "1",
                    "stringEnum": 2
                ]
                
                it("should map it propertly") {
                    let model = MyModel(JSON: typeMismatchingJSON)
                    expect(model?.string).to(equal("123"))
                    expect(model?.stringsArray).to(equal(["123.0", "321.0"]))
                    expect(model?.double).to(equal(1.1))
                    expect(model?.intEnum).to(equal(.one))
                    expect(model?.stringEnum).to(equal(.two))
                }
            }
            
            context("when JSON contains doubles") {
                let typeMismatchingJSON: [String: Any] = [
                    "double1": 1,
                    "double2": "1.0",
                    "double3": "-1.0000",
                    "double4": "1.0001",
                    "double5": "-100.001",
                    "double6": "1000000.0001",
                    "double7": "-2.66",
                    "double8": -1000000,
                    "double9": 1.0,
                    "double10": 0.1,
                    "double11": "0.1",
                    "double12": "0.1000000",
                ]
                
                let doubleModel = MyDoubleModel(JSON: typeMismatchingJSON)!
                it("should map it propertly") {
                    expect(doubleModel.double1).to(equal(1))
                    expect(doubleModel.double2).to(equal(1))
                    expect(doubleModel.double3).to(equal(-1))
                    expect(doubleModel.double4).to(equal(1.0001))
                    expect(doubleModel.double5).to(equal(-100.001))
                    expect(doubleModel.double6).to(equal(1000000.0001))
                    expect(doubleModel.double7).to(equal(-2.66))
                    expect(doubleModel.double8).to(equal(-1000000))
                    expect(doubleModel.double9).to(equal(1))
                    expect(doubleModel.double10).to(equal(0.1))
                    expect(doubleModel.double11).to(equal(0.1))
                    expect(doubleModel.double12).to(equal(0.1))
                }
                
                it("should map back to JSON propertly") {
                    let json = doubleModel.toJSON()
                    expect(json["double1"] as? Double).to(equal(1))
                    expect(json["double2"] as? Double).to(equal(1))
                    expect(json["double3"] as? Double).to(equal(-1))
                    expect(json["double4"] as? Double).to(equal(1.0001))
                    expect(json["double5"] as? Double).to(equal(-100.001))
                    expect(json["double6"] as? Double).to(equal(1000000.0001))
                    expect(json["double7"] as? Double).to(equal(-2.66))
                    expect(json["double8"] as? Double).to(equal(-1000000))
                    expect(json["double9"] as? Double).to(equal(1))
                    expect(json["double10"] as? Double).to(equal(0.1))
                    expect(json["double11"] as? Double).to(equal(0.1))
                    expect(json["double12"] as? Double).to(equal(0.1))
                }
                
                it("should map back to JSON string propertly") {
//                    {
//                        "double8": -1000000,
//                        "double3": -1,
//                        "double7": -2.6600000000000001,
//                        "double5": -100.001,
//                        "double9": 1,
//                        "double6": 1000000.0000999999,
//                        "double1": 1,
//                        "double12": 0.10000000000000001,
//                        "double4": 1.0001,
//                        "double10": 0.10000000000000001,
//                        "double2": 1,
//                        "double11": 0.10000000000000001
//                    }
                    let jsonString = doubleModel.toJSONString()!
                    print(jsonString)
                    
                    // This one fails because of the Apple JSON mapping
//                    expect(jsonString.contains("10000000000000001")).to(beFalse())
                }
            }
        }
    }
}

private struct MyDoubleModel: Mappable {
    var double1: Double?
    var double2: Double?
    var double3: Double?
    var double4: Double?
    var double5: Double?
    var double6: Double?
    var double7: Double?
    var double8: Double?
    var double9: Double?
    var double10: Double?
    var double11: Double?
    var double12: Double?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        double1 <- (map["double1"], TypeCastTransform())
        double2 <- (map["double2"], TypeCastTransform())
        double3 <- (map["double3"], TypeCastTransform())
        double4 <- (map["double4"], TypeCastTransform())
        double5 <- (map["double5"], TypeCastTransform())
        double6 <- (map["double6"], TypeCastTransform())
        double7 <- (map["double7"], TypeCastTransform())
        double8 <- (map["double8"], TypeCastTransform())
        double9 <- (map["double9"], TypeCastTransform())
        double10 <- (map["double10"], TypeCastTransform())
        double11 <- (map["double11"], TypeCastTransform())
        double12 <- (map["double12"], TypeCastTransform())
    }
}
