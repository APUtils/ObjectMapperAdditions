//
//  ISO8601TransformSpec.swift
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


class ISO8601JustDateTransformSpec: QuickSpec {
    override func spec() {
        describe("ISO8601JustDateTransform") {
            var transform: ISO8601JustDateTransform!
            let date = Date(timeIntervalSince1970: 0)
            let dateString = "1970-01-01"
            
            beforeEach {
                transform = ISO8601JustDateTransform()
            }
            
            it("should convert date string to Date") {
                expect(transform.transformFromJSON("1970-01-01")).to(equal(date))
            }
            
            it("should convert Date to date string") {
                expect(transform.transformToJSON(date)).to(equal(dateString))
            }
        }
    }
}

