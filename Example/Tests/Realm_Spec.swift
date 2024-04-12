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
            beforeEach {
                let realm = try! Realm(configuration: .init(deleteRealmIfMigrationNeeded: true))
                try! realm.write {
                    realm.deleteAll()
                }
            }
            
            context("when JSON contains proper type params") {
                let id = Int.random(in: ClosedRange(uncheckedBounds: (Int.min, Int.max)))
                let realmJSON: [String: Any] = [
                    "id": id,
                    "double": 1.1,
                    "optionalDouble": "2.2",
                    "string": "123",
                    "myOtherRealmModel": ["string":"string"],
                    "myOtherRealmModels": [["string":"string"], ["string":"string"]],
                    "myRealmMap": ["key":"value"],
                    "strings": ["123.0", "321.0"]
                ]
                
                it("should map properly from JSON to MyRealmModel") {
                    let model = MyRealmModel(JSON: realmJSON)
                    expect(model?.id).to(equal(id))
                    expect(model?.double).to(equal(1.1))
                    expect(model?.optionalDouble.value).to(equal(2.2))
                    expect(model?.string).to(equal("123"))
                    expect(model?.myOtherRealmModel?.string).to(equal("string"))
                    expect(model?.myOtherRealmModels.count).to(equal(2))
                    expect(model?.myOtherRealmModels[0].string).to(equal("string"))
                    expect(model?.myOtherRealmModels[1].string).to(equal("string"))
                    expect(model?.myRealmMap["key"]).to(equal("value"))
                    expect(Array(model!.strings)).to(equal(["123.0", "321.0"]))
                }
                
                it("should map properly from JSON to MyPersistedRealmModel") {
                    let model = MyPersistedRealmModel(JSON: realmJSON)
                    expect(model?.id).to(equal(id))
                    expect(model?.double).to(equal(1.1))
                    expect(model?.optionalDouble).to(equal(2.2))
                    expect(model?.string).to(equal("123"))
                    expect(model?.myOtherRealmModel?.string).to(equal("string"))
                    expect(model?.myOtherRealmModels.count).to(equal(2))
                    expect(model?.myOtherRealmModels[0].string).to(equal("string"))
                    expect(model?.myOtherRealmModels[1].string).to(equal("string"))
                    expect(model?.myRealmMap["key"]).to(equal("value"))
                    expect(Array(model!.strings)).to(equal(["123.0", "321.0"]))
                }
                
                context("and added to Realm") {
                    it("should be able to transform to JSON") {
                        var model = MyRealmModel(JSON: realmJSON)!
                        let realm = try! Realm()
                        try! realm.write({
                            realm.add(model)
                        })
                        
                        model = realm.object(ofType: MyRealmModel.self, forPrimaryKey: model.id)!
                        let json = model.toJSON()
                        expect(json.count).to(equal(8))
                    }
                }
            }
            
            context("when JSON contains wrong type params") {
                let realmJSON: [String: Any] = [
                    "id": "1",
                    "double": "1.1",
                    "optionalDouble": 2.2,
                    "string": 123,
                    "myOtherRealmModel": ["string":123],
                    "myOtherRealmModels": [["string":123], ["string":123]],
                    "strings": [123.0, 321.0]
                ]
                
                it("should map properly from JSON") {
                    let model = MyRealmModel(JSON: realmJSON)
                    expect(model?.id).to(equal(1))
                    expect(model?.double).to(equal(1.1))
                    expect(model?.optionalDouble.value).to(equal(2.2))
                    expect(model?.string).to(equal("123"))
                    expect(model?.myOtherRealmModel?.string).to(equal("123"))
                    expect(model?.myOtherRealmModels.count).to(equal(2))
                    expect(model?.myOtherRealmModels[0].string).to(equal("123"))
                    expect(model?.myOtherRealmModels[1].string).to(equal("123"))
                    expect(Array(model!.strings)).to(equal(["123.0", "321.0"]))
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
