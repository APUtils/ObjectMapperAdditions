// https://github.com/Quick/Quick

import Quick
import Nimble
import RealmSwift
import ObjectMapper
import ObjectMapperAdditions
import APExtensions
@testable import ObjectMapperAdditions_Example


class RealmSpec: QuickSpec {
    override func spec() {
        describe("Realm object") {
            context("when JSON contains proper type params") {
                let realmJSON: [String: Any] = [
                    "double": 1.1,
                    "optionalDouble": "2.2",
                    "string": "123",
                    "myOtherRealmModel": [:],
                    "myOtherRealmModels": [[:], [:]],
                    "strings": ["123.0", "321.0"]
                ]
                
                it("should map properly from JSON") {
                    let model = MyRealmModel(JSON: realmJSON)
                    expect(model?.double).to(equal(1.1))
                    expect(model?.optionalDouble.value).to(equal(2.2))
                    expect(model?.string).to(equal("123"))
                    expect(Array(model!.strings)).to(equal(["123.0", "321.0"]))
                    expect(model?.myOtherRealmModels.count).to(equal(2))
                }
            }
            
            
            context("filled with data") {
                var realm: Realm!
                var model: MyRealmModel!
                
                beforeEach {
                    realm = try! Realm()
                    try! realm.write {
                        realm.deleteAll()
                    }
                    
                    model = MyRealmModel()
                    model.double = 1.1
                    model.optionalDouble.value = 2.2
                    model.string = "123"
                    model.myOtherRealmModel = MyOtherRealmModel()
                    model.myOtherRealmModels.append(objectsIn: [MyOtherRealmModel(), MyOtherRealmModel()])
                    model.strings.append(objectsIn: ["123.0", "321.0"])
                }
                
                it("should be saved and restored successfully") {
                    try! realm.write {
                        realm.add(model)
                    }
                    
                    let storedModel = realm.objects(MyRealmModel.self).first!
                    expect(model.double).to(equal(storedModel.double))
                    expect(model.string).to(equal(storedModel.string))
                    expect(model.myOtherRealmModel).to(equal(storedModel.myOtherRealmModel))
                    expect(Array(model.myOtherRealmModels)).to(equal(Array(storedModel.myOtherRealmModels)))
                    expect(Array(model.strings)).to(equal(Array(storedModel.strings)))
                }
            }
        }
    }
}
