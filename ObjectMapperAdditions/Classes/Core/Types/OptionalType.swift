//
//  OptionalType.swift
//  ObjectMapperAdditions
//
//  Created by Anton Plebanovich on 17.11.21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import Foundation

// Take from https://github.com/RxSwiftCommunity/RxOptional/blob/master/Sources/RxOptional/OptionalType.swift
// Originally from here: https://github.com/artsy/eidolon/blob/24e36a69bbafb4ef6dbe4d98b575ceb4e1d8345f/Kiosk/Observable%2BOperators.swift#L30-L40
// Credit to Artsy and @ashfurrow
public protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
    init(nilLiteral: ())
}

extension Optional: OptionalType {
    /// Cast `Optional<Wrapped>` to `Wrapped?`
    public var value: Wrapped? { self }
}
