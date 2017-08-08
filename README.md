# ObjectMapperAdditions

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/ObjectMapperAdditions.svg?style=flat)](http://cocoapods.org/pods/ObjectMapperAdditions)
[![License](https://img.shields.io/cocoapods/l/ObjectMapperAdditions.svg?style=flat)](http://cocoapods.org/pods/ObjectMapperAdditions)
[![Platform](https://img.shields.io/cocoapods/p/ObjectMapperAdditions.svg?style=flat)](http://cocoapods.org/pods/ObjectMapperAdditions)
[![CI Status](http://img.shields.io/travis/anton-plebanovich/ObjectMapperAdditions.svg?style=flat)](https://travis-ci.org/anton-plebanovich/ObjectMapperAdditions)

- Adds simple calls to include NULL values in output JSON.
- Adds ability to simply type cast JSON values to specified type.
- Adds ability to map Swift base type arrays into Realm arrays

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

If you are going to use Realm part, add those frameworks: `ObjectMapperAdditions`, `ObjectMapperAdditionsRealm`, `ObjectMapper`, `Realm`, `RealmSwift`, `RealmAdditions`.

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

See example and tests projects for more details.

#### Realm Features

This part of ObjectMapperAdditions solves issues that prevent simply using ObjectMapper and Realm in one model. There is already [ObjectMapper-Realm](https://github.com/Jakenberg/ObjectMapper-Realm) framework which allows to transform arrays of custom type to realm lists, but it can't transform simple type arrays.

``` swift
import Foundation
import ObjectMapper
import ObjectMapperAdditions
import ObjectMapper_Realm
import RealmSwift


class MyRealmModel: Object, Mappable {
    dynamic var double: Double = 0
    dynamic var string: String?
    dynamic var myOtherRealmModel: MyOtherRealmModel?
    
    // Please take a note it's `var` and is not optional
    var myOtherRealmModels: List<MyOtherRealmModel> = List<MyOtherRealmModel>()
    
    // Strings array will be casted to List<RealmString>
    var strings: List<RealmString> = List<RealmString>()
    
    // You could add computed property to simplify set and get:
    var _strings: [String] {
        get {
            return strings.map({ $0.value })
        }
        set {
            strings.removeAll()
            strings.append(objectsIn: newValue.map(RealmString.init(swiftValue:)))
        }
    }
    
    // Do not forget to ignore our helper property
    override static func ignoredProperties() -> [String] {
        return ["_strings"]
    }

    required convenience init?(map: Map) { self.init() }

    func mapping(map: Map) {
        // .toJSON() requires Realm write transaction or it'll crash
        let isWriteRequired = realm != nil && realm?.isInWriteTransaction == false
        isWriteRequired ? realm?.beginWrite() : ()

        // Same as for ordinary model
        double <- (map["double"], DoubleTransform())
        string <- (map["string"], StringTransform())
        myOtherRealmModel <- map["myOtherRealmModel"]
        
        // Using ObjectMapper+Realm's ListTransform to transform custom types
        myOtherRealmModels <- (map["myOtherRealmModels"], ListTransform<MyOtherRealmModel>())
        
        // Using ObjectMapperAdditions's RealmTypeCastTransform
        strings <- (map["strings"], RealmTypeCastTransform<RealmString>())
        
        // You could also use RealmTransform if you don't like type cast
//        strings <- (map["strings"], RealmTransform<RealmString>())

        isWriteRequired ? try? realm?.commitWrite() : ()
    }
}
```

Swift arrays cast to realm arrays this way: `[String]` -> `List<RealmString>`, `[Int]` -> `List<RealmInt>`, `[Double]` -> `List<RealmDouble>`, `[Bool]` -> `List<RealmBool>`.

**Be sure to check that properties of type `List` are not dynamic and not optional. Also despite of they defined as `var` they should be handled as a constants. Use `.removeAll()` and `append(objectsIn:)` methods to change `List` content**

See example and tests projects for more details.

## Contributions

Any contribution is more than welcome! You can contribute through pull requests and issues on GitHub.

## Author

Anton Plebanovich, anton.plebanovich@gmail.com

## License

ObjectMapperAdditions is available under the MIT license. See the LICENSE file for more info.
