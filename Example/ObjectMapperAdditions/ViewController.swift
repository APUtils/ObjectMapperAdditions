//
//  ViewController.swift
//  ObjectMapperAdditions
//
//  Created by Anton Plebanovich on 07/17/2017.
//  Copyright (c) 2017 Anton Plebanovich. All rights reserved.
//

import UIKit
import ObjectMapperAdditions
import RealmSwift


class ViewController: UIViewController {
    
    //-----------------------------------------------------------------------------
    // MARK: - UIViewController Methods
    //-----------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            "myOtherRealmModel": [:],
            "myOtherRealmModels": [[:], [:]],
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
            success = success && Array(realmModel._strings) == Array(storedModel!._strings) && realmModel._strings == (realmJSON["strings"] as! [String])
            
            print(success ? "Data is not lost" : "Some data is lost")
        }
    }
}
