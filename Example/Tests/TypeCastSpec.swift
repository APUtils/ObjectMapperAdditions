// https://github.com/Quick/Quick

import Quick
import Nimble
import ObjectMapper
import ObjectMapper_Realm
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
        }
    }
}
