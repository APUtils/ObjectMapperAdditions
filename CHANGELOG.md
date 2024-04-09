# Change Log
All notable changes to this project will be documented in this file.
`ObjectMapperAdditions` adheres to [Semantic Versioning](http://semver.org/).


## [13.2.1](https://github.com/APUtils/LogsManager/releases/tag/13.2.1)
Released on `2024-04-09`

#### Added
- `RealmSwift.Map` mapping support


## [13.2.0](https://github.com/APUtils/LogsManager/releases/tag/13.2.0)
Released on `2024-03-27`

#### Added
- `performMapping` safety for frozen and invalidated objects
- Carriage return support as a whitespace character
- [EnumTypeCastTransform] Report unknown cases
- [Map] additions

#### Changed
- `<-` operator for `List` and `RealmProperty` now does nothing on key absense to mimic the same behavior of `ObjectMapper`
- `<-` operator for `List` now replace existing entries on subsequent mapping


## [13.1.0](https://github.com/APUtils/LogsManager/releases/tag/13.1.0)
Released on `2023-04-25`

#### Added
- `<-` operator for `List` and `RealmProperty` with custom transform

#### Changed
- `<-` operator for `List` and `RealmProperty` now does nothing on key absense to mimic the same behavior of `ObjectMapper`
- `<-` operator for `List` now replace existing entries on subsequent mapping


## [13.0.3](https://github.com/APUtils/LogsManager/releases/tag/13.0.3)
Released on `2023-04-25`

#### Added
- [EmbeddedObject] `performMapping(_:)`


## [13.0.0](https://github.com/APUtils/LogsManager/releases/tag/13.0.0)
Released on `2023-04-25`

#### Changed
- Examples
- Reverted `12.0.0` version deprecations
- `ObjectMapperAdditions` and `ObjectMapperAdditionsCore` SPM frameworks separation

#### Deprecated
- Carthage

#### Fixed
- SPM and Carthage builds


## [12.0.0](https://github.com/APUtils/LogsManager/releases/tag/12.0.0)
Released on `2023-02-23`

#### Added
- `<-` operator to map and typecast `List` and `RealmProperty`
- [Object] `performMapping(_:)` method to simplify safe mappings

#### Changed
- Using `cancelWrite` instead of `commitWrite` for Realm models mapping

#### Deprecated
- `RealmListTransform` in favor of `<-` operator
- `RealmPropertyTransform`
- `RealmPropertyTypeCastTransform` in favor of `<-` operator
- `RealmTransform`
- `RealmTypeCastTransform` in favor of `<-` operator

#### Removed
- Deprecated `RealmOptionalTransform`
- Deprecated `RealmOptionalTypeCastTransform`


## [11.0.0](https://github.com/APUtils/LogsManager/releases/tag/11.0.0)
Released on `2023-01-29`

#### Changed
- Access modifier examples update
- Better code reuse
- Better log messages
- Consider empty string as `nil` for casting
- Considering `-` string as `nil`
- Min supported OS versions rised

#### Fixed
- Error message and param name in data error log


## [10.0.2](https://github.com/APUtils/ObjectMapperAdditions/releases/tag/10.0.2)
Released on `2022-07-28`

#### Added
- Int to Double rounding warning


## [10.0.1](https://github.com/APUtils/ObjectMapperAdditions/releases/tag/10.0.1)
Released on `2022-07-28`

#### Added
- More error reports on failure casts


## [10.0.0](https://github.com/APUtils/ObjectMapperAdditions/releases/tag/10.0.0)
Released on `2022-07-07`

#### Changed
- Some transformers are now singletons


## [9.0.0](https://github.com/APUtils/ObjectMapperAdditions/releases/tag/9.0.0)
Released on `2022-07-07`

#### Added
- Array<BaseMappable> toJSONData()
- BaseMappable toJSONString(options:)
- Set<BaseMappable> toJSONData()
- [BaseMappable] toJSONString(options:)

#### Changed
- Check for closing brackets before creation
- Do not fail on whitespaces
- Search for non-whitespace characters instead of warning
- `RoutableLogger.logError` instead of `print` for type cast errors

#### Improved
- Better error report
- Better invalid JSON messages

#### Tests
- Create specs

## [8.2.0](https://github.com/APUtils/ObjectMapperAdditions/releases/tag/8.2.0)
Released on 11/17/2021.

#### Added
- [BaseMappable?].create(jsonData:)
- [BaseMappable?].safeCreate(jsonData:)
- [BaseMappable].create(jsonData:)
- [BaseMappable].create(jsonString:)
- [BaseMappable].safeCreate(jsonData:)
- [BaseMappable].safeCreate(jsonString:)
- [BaseMappable].toJSONData()
- [ImmutableMappable].create(jsonData:)
- [ImmutableMappable].create(jsonString:)
- [ImmutableMappable].safeCreate(jsonData:)
- [ImmutableMappable].safeCreate(jsonString:)
- [Mappable].create(jsonData:)
- [Mappable].create(jsonString:)
- [Mappable].safeCreate(jsonData:)
- [Mappable].safeCreate(jsonString:)
- [[BaseMappable]].create(jsonData:)
- [[BaseMappable]].create(jsonString:)
- [[BaseMappable]].safeCreate(jsonData:)
- [[BaseMappable]].safeCreate(jsonString:)


## [8.1.0](https://github.com/APUtils/ObjectMapperAdditions/releases/tag/8.1.0)
Released on 11/07/2021.

#### Added
- RealmPropertyTransform [[@Drusy](https://github.com/Drusy)]
- RealmPropertyTypeCastTransform [[@Drusy](https://github.com/Drusy)]

#### Changed 
- Deprecated RealmOptionalTransform
- Deprecated RealmOptionalTypeCastTransform


## [8.0.0](https://github.com/APUtils/ObjectMapperAdditions/releases/tag/8.0.0)
Released on 04/15/2021.

#### Changed
- SPM support for the latest Realm and ObjectMapper versions [[@dams229](https://github.com/dams229)]
- iOS 11.0 min
- OSx 10.10 min

#### Fixed 
- Carthage project


## [7.0.0](https://github.com/APUtils/ObjectMapperAdditions/releases/tag/7.0.0)
Released on 05/20/2020.

#### Changed
- Set minimum iOS deployment target to 10.0 to match ObjectMapper requirements.


## [6.0.2](https://github.com/APUtils/ObjectMapperAdditions/releases/tag/6.0.2)
Released on 07/25/2019.

#### Added
- MacOS support for Cocoapods and Carthage


## [6.0.1](https://github.com/APUtils/ObjectMapperAdditions/releases/tag/6.0.1)
Released on 05/23/2019.

#### Fixed
- Swift 5.0 support fix.

#### Changed
- Removed dependency on `ObjectMapper+Realm` framework.


## [6.0.0](https://github.com/APUtils/ObjectMapperAdditions/releases/tag/6.0.0)
Released on 04/04/2019.

#### Added
- Swift 5.0 support
- EnumTypeCastTransform


## [5.0.0](https://github.com/APUtils/ObjectMapperAdditions/releases/tag/5.0.0)
Released on 12/30/2018.

#### Added
- Swift 4.2


## [4.2.1](https://github.com/APUtils/ObjectMapperAdditions/releases/tag/4.2.1)
Released on 10/13/2018.

#### Added
- Cocoapods support for tvOS 9.0


## [4.2.0](https://github.com/APUtils/ObjectMapperAdditions/releases/tag/4.2.0)
Released on 10/13/2018.

#### Added
- Cocoapods support for tvOS

#### Fixed
- Warnings


## [4.1.0](https://github.com/APUtils/ObjectMapperAdditions/releases/tag/4.1.0)
Released on 03/27/2018.

#### Added
- RealmOptionalTransform and RealmOptionalTypeCastTransform to trannsform to RealmOptional type


## [4.0.0](https://github.com/APUtils/ObjectMapperAdditions/releases/tag/4.0.0)
Released on 02/09/2018.

#### Added
- Realm 3 support for basic types.

#### Removed
- RealmAdditions dependency is not required anymore.

## [3.0.5](https://github.com/APUtils/ObjectMapperAdditions/releases/tag/3.0.5)
Released on 09/26/2017.

#### Added
- ISO8601JustDateTransform. Transforms ISO8601 **date** string to/from Date.


## [3.0.4](https://github.com/APUtils/ObjectMapperAdditions/releases/tag/3.0.4)
Released on 09/26/2017.

#### Added
- TimestampTransform. Transforms UNIX timestamp (aka POSIX timestamp or epoch) to/from Date.


## [3.0.1](https://github.com/APUtils/ObjectMapperAdditions/releases/tag/3.0.1)
Released on 09/21/2017.

#### Fixed
- Carthage support


## [3.0.0](https://github.com/APUtils/ObjectMapperAdditions/releases/tag/3.0.0)
Released on 09/21/2017.

Swift 4 migration


## [2.0.4](https://github.com/APUtils/ObjectMapperAdditions/releases/tag/2.0.4)
Released on 08/08/2017.

#### Added
- Carthage support


## [2.0.0](https://github.com/APUtils/ObjectMapperAdditions/releases/tag/2.0.0)
Released on 07/28/2017.

#### Changed
- Moved core functionality to Core subspec.
- Realm subspec to convert simple type arrays to realm objects.


## [1.1.1](https://github.com/APUtils/ObjectMapperAdditions/releases/tag/1.1.1)
Released on 07/18/2017.

#### Fixed
- Added public inits.


## [1.1.0](https://github.com/APUtils/ObjectMapperAdditions/releases/tag/1.1.0)
Released on 07/18/2017.

#### Added
- ObjectMapper+Additions.


#### Fixed
- Public extensions fix.


#### Changed
- Cases reordered.


## [1.0.0](https://github.com/APUtils/ObjectMapperAdditions/releases/tag/1.0.0)
Released on 07/17/2017.

#### Added
- Initial release of ObjectMapperAdditions.
  - Added by [Anton Plebanovich](https://github.com/anton-plebanovich).
