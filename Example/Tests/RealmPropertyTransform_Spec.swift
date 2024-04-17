//
//  RealmPropertyTransform_Spec.swift
//  ObjectMapperAdditions
//
//  Created by Anton Plebanovich on 7.11.21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import Quick
import Nimble
import ObjectMapper
import ObjectMapperAdditions
import APExtensions
import RealmSwift
@testable import ObjectMapperAdditions_Example

class RealmPropertyTransform_Spec: QuickSpec {
    override class func spec() {
        describe("RealmPropertyTransform") {
            it("should map from JSON") {
                let t = RealmPropertyTransform<Double>()
                expect(t.transformFromJSON(1.0)?.value) == 1.0
                expect(t.transformFromJSON("1.0")?.value).to(beNil())
            }
            
            it("should map to JSON") {
                let t = RealmPropertyTransform<Double>()
                let property = RealmProperty<Double?>()
                property.value = 1.0
                expect(t.transformToJSON(property) as? Double) == 1.0
            }
        }
    }
}
