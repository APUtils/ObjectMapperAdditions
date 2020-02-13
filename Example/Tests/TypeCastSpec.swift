// https://github.com/Quick/Quick

import Quick
import Nimble
import ObjectMapper
import ObjectMapperAdditions
import APExtensions
@testable import ObjectMapperAdditions_Example


class TypeCastSpec: QuickSpec {
    override func spec() {
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
                ]
                
                it("should map it propertly") {
                    let model = MyDoubleModel(JSON: typeMismatchingJSON)
                    expect(model?.double1).to(equal(1))
                    expect(model?.double2).to(equal(1))
                    expect(model?.double3).to(equal(-1))
                    expect(model?.double4).to(equal(1.0001))
                    expect(model?.double5).to(equal(-100.001))
                    expect(model?.double6).to(equal(1000000.0001))
                    expect(model?.double7).to(equal(-2.66))
                    expect(model?.double8).to(equal(-1000000))
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
    }
}
