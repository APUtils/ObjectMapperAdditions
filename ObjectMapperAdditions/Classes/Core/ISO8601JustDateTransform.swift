//
//  ISO8601Transform.swift
//  ObjectMapperAdditions
//
//  Created by Anton Plebanovich on 9/26/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import ObjectMapper


fileprivate extension DateFormatter {
    fileprivate convenience init(withFormat format: String, timeZone: TimeZone) {
        self.init()
        
        self.timeZone = timeZone
        dateFormat = format
    }
}


/// Transforms ISO8601 date string to/from Date. ObjectMapper's `ISO8601DateTransform` actually is date and time transform.
open class ISO8601JustDateTransform: DateFormatterTransform {
    static let reusableISODateFormatter = DateFormatter(withFormat: "yyyy-MM-dd", timeZone: TimeZone(secondsFromGMT: 0)!)
    
    public init() {
        super.init(dateFormatter: ISO8601JustDateTransform.reusableISODateFormatter)
    }
}
