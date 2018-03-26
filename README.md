# ObjectMapperAdditions

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/ObjectMapperAdditions.svg?style=flat)](http://cocoapods.org/pods/ObjectMapperAdditions)
[![License](https://img.shields.io/cocoapods/l/ObjectMapperAdditions.svg?style=flat)](http://cocoapods.org/pods/ObjectMapperAdditions)
[![Platform](https://img.shields.io/cocoapods/p/ObjectMapperAdditions.svg?style=flat)](http://cocoapods.org/pods/ObjectMapperAdditions)
[![CI Status](http://img.shields.io/travis/APUtils/ObjectMapperAdditions.svg?style=flat)](https://travis-ci.org/APUtils/ObjectMapperAdditions)

- Adds simple calls to include NULL values in output JSON.
- Adds ability to simply type cast JSON values to specified type.
- Adds ability to map Swift base type arrays into Realm arrays.
- Adds `TimestampTransform` to simply transform to/from UNIX timestamps.
- Adds `ISO8601JustDateTransform` to simplty transform to/from ISO8601 **date** string. Because ObjectMapper's `ISO8601DateTransform` actually is **date and time** transform.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

#### Carthage

Please check [official guide](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos)

Cartfile:

```
github "APUtils/ObjectMapperAdditions"
```

If you do not need Realm part, add those frameworks: `ObjectMapperAdditions`, `ObjectMapper`.

If you are going to use Realm part, add those frameworks: `ObjectMapperAdditions`, `ObjectMapperAdditionsRealm`, `ObjectMapper`, `Realm`, `RealmSwift`.

#### CocoaPods

ObjectMapperAdditions is available through [CocoaPods](http://cocoapods.org). 

To install Core features, simply add the following line to your Podfile:

```ruby
pod 'ObjectMapperAdditions/Core'
```

To add Realm transform to your project add the following line to your Podfile:

```ruby
pod 'ObjectMapperAdditions/Realm'
```

## Usage

#### Core Features

It's a common case when app gets Int in JSON instead of String even if backend guy said you it'll be String. Worst of all sometimes it could be String and sometimes something else so it'll look like you released broken app even if you tested it well.

After several projects I made a rule for myself: `Never trust a backend!`. I always make optional fields and cast values to type I'll use. Right now I'm using a great framework `ObjectMapper` to map my objects but it doesn't have transforms I need so I wrote them as this separate pod.

Example model:

``` swift
import Foundation
import ObjectMapper
import ObjectMapperAdditions


struct MyModel: Mappable {
    var string: String?
    var stringsArray: [String]?
    var double: Double?
    var myOtherModel: MyOtherModel?
    var myOtherModelsArray: [MyOtherModel]?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        // You could specify proper type transform directly
        string <- (map["string"], StringTransform())
        
        // Or you could just use TypeCastTransform
        string <- (map["string"], TypeCastTransform())
        
        // No doubt it also works with Double
        double <- (map["double"], TypeCastTransform())
        
        // Works with arrays too but for TypeCastTransform you must specify type
        stringsArray <- (map["stringsArray"], TypeCastTransform<String>())
        
        // Or just use StringTransform directly
        stringsArray <- (map["stringsArray"], StringTransform())
        
        // No need to transform your types. They should specify transforms by themselfs.
        myOtherModel <- map["myOtherModel"]
        myOtherModelsArray <- map["myOtherModelsArray"]
    }
}
```

Right now there are 4 base type transforms you could use: `BoolTransform`, `DoubleTransform`, `IntTransform` and `StringTransform`. But for basic types it's easier to just use `TypeCastTransform` which will type cast to proper type automatically.

Moreover this pod has extension to simplify creation of JSON with NULL values included from objects. Just call `.toJSON(shouldIncludeNilValues: true)` on `BaseMappable` object or array/set.

Date transformers example usage:
```swift
// If date in timestamp format (1506423767)
date <- (map["date"], TimestampTransform())

// If date in ISO8601 full-date format (yyyy-MM-dd)
date <- (map["date"], ISO8601JustDateTransform())
```

See example and tests projects for more details.

#### Realm Features

This part of ObjectMapperAdditions solves issues that prevent simply using ObjectMapper and Realm in one model. There is already [ObjectMapper-Realm](https://github.com/Jakenberg/ObjectMapper-Realm) framework which allows to transform arrays of custom type to realm lists, but it can't transform simple type arrays nor optional values.

``` swift
import Foundation
import ObjectMapper
import ObjectMapperAdditions
import ObjectMapper_Realm
import RealmSwift


class MyRealmModel: Object, Mappable {
    @objc dynamic var double: Double = 0
    
    // Please take a note it's `var` and is not optional
    // However new value should be assigned through `.value`
    var optionalDouble = RealmOptional<Double>()
    
    @objc dynamic var string: String?
    @objc dynamic var myOtherRealmModel: MyOtherRealmModel?
    
    // Please take a note it's `var` and is not optional
    // However, new value should be assigned through `.append(_:)`
    var myOtherRealmModels = List<MyOtherRealmModel>()
    
    // Strings array will be casted to List<RealmString>
    var strings: List<String> = List<String>()

    required convenience init?(map: Map) { self.init() }

    func mapping(map: Map) {
        // .toJSON() requires Realm write transaction or it'll crash
        let isWriteRequired = realm != nil && realm?.isInWriteTransaction == false
        isWriteRequired ? realm?.beginWrite() : ()

        // Same as for ordinary model
        double <- (map["double"], DoubleTransform())
        
        // Using ObjectMapperAdditions's RealmOptionalTypeCastTransform
        optionalDouble <- (map["optionalDouble"], RealmOptionalTypeCastTransform())
        // You could also use RealmTransform if you don't like type cast
//        optionalDouble <- (map["optionalDouble"], RealmOptionalTransform())

        string <- (map["string"], StringTransform())
        myOtherRealmModel <- map["myOtherRealmModel"]
        
        // Using ObjectMapper+Realm's ListTransform to transform custom types
        myOtherRealmModels <- (map["myOtherRealmModels"], ListTransform<MyOtherRealmModel>())
        
        // Using ObjectMapperAdditions's RealmTypeCastTransform
        strings <- (map["strings"], RealmTypeCastTransform())
        // You could also use RealmTransform if you don't like type cast
//        strings <- (map["strings"], RealmTransform())

        isWriteRequired ? try? realm?.commitWrite() : ()
    }
}```

Swift optionals cast to realm optionals this way: `Int?` -> `RealmOptional<Int>`, `Double?` -> `RealmOptional<Double>`, `Bool?` -> `RealmOptional<Bool>`, etc.

Swift arrays cast to realm arrays this way: `[String]` -> `List<String>`, `[Int]` -> `List<String>`, `[Double]` -> `List<Double>`, `[Bool]` -> `List<Bool>`, etc.

**Be sure to check that properties of type `RealmOptional` and `List` are not dynamic nor optional. Also despite of they defined as `var` they should be handled as constants if model is added to Realm. Use `.value` to change `RealmOptional` value or use `.removeAll()` and `append(objectsIn:)` methods to change `List` content**

See example and tests projects for more details.

## Contributions

Any contribution is more than welcome! You can contribute through pull requests and issues on GitHub.

## Author

Anton Plebanovich, anton.plebanovich@gmail.com

## License

ObjectMapperAdditions is available under the MIT license. See the LICENSE file for more info.
