//
//  MongoDateTransform_Spec.swift
//  ObjectMapperAdditions
//
//  Created by Anton Plebanovich on 8.06.25.
//  Copyright © 2025 Anton Plebanovich. All rights reserved.
//

import Quick
import Nimble
import ObjectMapper
import ObjectMapperAdditions
@testable import ObjectMapperAdditions_Example

class MongoDateTransform_Spec: QuickSpec {
    override class func spec() {
        describe("MongoDateTransform") {
            it("should map from JSON") {
                let t = MongoDateTransform.shared
                expect(t.transformFromJSON(["$date": "2022-01-01T00:00:00.000+00:00"])?.timeIntervalSince1970) == 1640995200
                expect(t.transformFromJSON(["$date": "2022-01-01T00:00:00.000Z"])?.timeIntervalSince1970) == 1640995200
                expect(t.transformFromJSON(["$date": "2022-01-01T00:00:00+00:00"])?.timeIntervalSince1970) == 1640995200
                expect(t.transformFromJSON(["$date": "2022-01-01T00:00:00Z"])?.timeIntervalSince1970) == 1640995200
                expect(t.transformFromJSON(["$date": ["$numberLong":1640995200000]])?.timeIntervalSince1970) == 1640995200
            }
            
            it("should map to JSON") {
                let t = MongoDateTransform.shared
                expect(t.transformToJSON(Date(timeIntervalSince1970: 1640995200))?.dictionary(forKey: "$date")?.int(forKey: "$numberLong")) == 1640995200000
                expect(t.transformToJSON(Date(timeIntervalSince1970: 1640995200.001))?.dictionary(forKey: "$date")?.int(forKey: "$numberLong")) == 1640995200001
            }
        }
    }
}
