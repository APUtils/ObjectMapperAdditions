//
//  ISO8601DateFormatter+Additions.swift
//  Pods
//
//  Created by Anton Plebanovich on 27.12.24.
//  Copyright © 2024 Anton Plebanovich. All rights reserved.
//

import Foundation

extension ISO8601DateFormatter {
    static let `default`: ISO8601DateFormatter = ISO8601DateFormatter()
    
    static let withMillisAndTimeZone: ISO8601DateFormatter = {
        let df = ISO8601DateFormatter()
        df.formatOptions = [
            .withInternetDateTime,
            .withDashSeparatorInDate,
            .withColonSeparatorInTime,
            .withTimeZone,
            .withFractionalSeconds,
            .withColonSeparatorInTimeZone
        ]
        
        return df
    }()
}
