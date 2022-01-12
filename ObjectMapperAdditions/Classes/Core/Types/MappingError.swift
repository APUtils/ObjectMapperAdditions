//
//  MappingError.swift
//  ObjectMapperAdditions
//
//  Created by Anton Plebanovich on 16.11.21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import Foundation

public enum MappingError: Error {
    case emptyData
    case invalidJSON(message: String)
    case unknownType
}
