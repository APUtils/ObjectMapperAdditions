//
//  TimestampTransformSpec.swift
//  ObjectMapperAdditions
//
//  Created by Anton Plebanovich on 9/26/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import APExtensions
import Nimble
import ObjectMapper
import ObjectMapperAdditions
import Quick


class TimestampTransformSpec: QuickSpec {
    override func spec() {
        describe("TimestampTransform") {
            var transform: TimestampTransform!
            
            beforeEach {
                transform = TimestampTransform()
            }
            
            it("should convert int timestamp to Date") {
                expect(transform.transformFromJSON(0)).to(equal(Date(timeIntervalSince1970: 0)))
            }
            
            it("should convert double timestamp to Date") {
                expect(transform.transformFromJSON(0.0)).to(equal(Date(timeIntervalSince1970: 0.0)))
            }
            
            it("should convert string timestamp to Date") {
                expect(transform.transformFromJSON("0.0")).to(equal(Date(timeIntervalSince1970: 0.0)))
            }
            
            it("should convert date to Int timestamp") {
                expect(transform.transformToJSON(Date(timeIntervalSince1970: 0.0))).to(equal(0))
            }
        }
    }
}
