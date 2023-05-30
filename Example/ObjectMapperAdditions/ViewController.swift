//
//  ViewController.swift
//  ObjectMapperAdditions
//
//  Created by Anton Plebanovich on 07/17/2017.
//  Copyright (c) 2017 Anton Plebanovich. All rights reserved.
//

import UIKit
import APExtensions
import ObjectMapperAdditions
import RealmSwift


class ViewController: UIViewController {
    
    //-----------------------------------------------------------------------------
    // MARK: - UIViewController Methods
    //-----------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let spaces = String(repeating: " ", count: 10_000_000)
        let string = " {\(spaces)\(spaces)} "
        
        let data = string.data(using: .utf8)!
        
        let date1 = Date()
        _ = try! MyModel.create(jsonString: string)
        print("From string: ******** %f", Date().timeIntervalSince(date1))
        
        let date2 = Date()
        _ = try! MyModel.create(jsonData: data)
        print("From data: ******** %f", Date().timeIntervalSince(date2))
        
        //-----------------------------------------------------------------------------
        // MARK: - ISO8601Formatter
        //-----------------------------------------------------------------------------
        
        let date = Date()
        let dateToDateString = ISO8601JustDateTransform.shared.transformToJSON(date)!
        let dateStringToDate = ISO8601JustDateTransform.shared.transformFromJSON(dateToDateString)!
        print("Date - \(date) to ISO8601 date string transform - \(dateToDateString)")
        print("ISO8601 date string - \(dateToDateString) to date transform - \(dateStringToDate)")
        
        //-----------------------------------------------------------------------------
        // MARK: - TimestampTransform
        //-----------------------------------------------------------------------------
        
        let dateToTimestamp = TimestampTransform.shared.transformToJSON(date)!
        let timestampToDate = TimestampTransform.shared.transformFromJSON(dateToTimestamp)!
        print("Date - \(date) to timestamp transform - \(dateToTimestamp)")
        print("Timestamp - \(dateToTimestamp) to date transform - \(timestampToDate)")
        
        //-----------------------------------------------------------------------------
        // MARK: - Type Cast Example
        //-----------------------------------------------------------------------------
        
        let typeMatchingJSON: [String: Any] = [
            "string": "123",
            "stringsArray": ["123.0", "321.0"],
            "double": 1.1
        ]
        
        let typeMismatchingJSON: [String: Any] = [
            "string": 123,
            "stringsArray": [123.0, 321.0],
            "double": "1.1"
        ]
        
        // Check if type cast was successful
        print(MyModel(JSON: typeMatchingJSON) == MyModel(JSON: typeMismatchingJSON) ? "Type cast success" : "Type cast fail")
        
        //-----------------------------------------------------------------------------
        // MARK: - Realm Example
        //-----------------------------------------------------------------------------
        
        let realmJSON: [String: Any] = [
            "double": 1.1,
            "string": "123",
            "myOtherRealmModel": [String: Any](),
            "myOtherRealmModels": [[String: Any](), [String: Any]()],
            "strings": ["123.0", "321.0"]
        ]
        
        let realm = try? Realm()
        // Create model from JSON and store it to realm
        if let realmModel = MyRealmModel(JSON: realmJSON) {
            try? realm?.write {
                realm?.deleteAll()
                realm?.add(realmModel)
            }
            
            // Get stored model
            let storedModel = realm?.objects(MyRealmModel.self).first
            
            // Checking that all data still there and same as in JSON
            var success = true
            success = success && realmModel.double == storedModel?.double && realmModel.double == realmJSON.double(forKey: "double")
            success = success && realmModel.string == storedModel?.string && realmModel.string == realmJSON.string(forKey: "string")
            success = success && realmModel.myOtherRealmModel == storedModel?.myOtherRealmModel
            success = success && Array(realmModel.myOtherRealmModels) == Array(storedModel!.myOtherRealmModels)
            success = success && Array(realmModel.strings) == Array(storedModel!.strings) && Array(realmModel.strings) == (realmJSON["strings"] as! [String])
            
            print(success ? "Data is not lost" : "Some data is lost")
        }
    }
}
