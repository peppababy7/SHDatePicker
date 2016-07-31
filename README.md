# SHDatePicker

[![CI Status](http://img.shields.io/travis/@harushuu/SHDatePicker.svg?style=flat)](https://travis-ci.org/@harushuu/SHDatePicker)
[![Version](https://img.shields.io/cocoapods/v/SHDatePicker.svg?style=flat)](http://cocoapods.org/pods/SHDatePicker)
[![License](https://img.shields.io/cocoapods/l/SHDatePicker.svg?style=flat)](http://cocoapods.org/pods/SHDatePicker)
[![Platform](https://img.shields.io/cocoapods/p/SHDatePicker.svg?style=flat)](http://cocoapods.org/pods/SHDatePicker)

## Screenshots
![image](https://github.com/harushuu/SHDatePicker/raw/master/Screenshots.gif)

## Installation

With [CocoaPods](http://cocoapods.org/), add this line to your `Podfile`.

```
pod 'SHDatePicker'
```

and run `pod install`, then you're all done!

## How to use

```objc
SHDatePicker *datePicker = [[SHDatePicker alloc] initWithCompleteHandle:^(NSDate *selectedDate, NSString *selectedDateString) {
    code... 
}];
[datePicker updateHiddenStatus];
```

## Summary

A simple date picker.
You can custom minute interval and how many days will show.

First init and calculate default datasource only need 95ms. So do not worry about performance
DataSource only refresh after time interval 


default init

```objc
// default dayCount is 7 days;
// default minuteInterval is 5 minutes;
// default firstMinuteInterval is 5 * 60 secend;

- (instancetype)initWithCompleteHandle:(SHDatePickerCompleteHandle)completeHandle;

```

custom init

```objc
- (instancetype)initWithDefaultDayCount:(NSInteger)dayCount 
                         minuteInterval:(NSInteger)minuteInterval 
                    firstMinuteInterval:(NSInteger)firstMinuteInterval 
                         customLanguage:(SHDateLanguageModel *)customLanguage 
                         completeHandle:(SHDatePickerCompleteHandle)completeHandle;

```

custom your local language

Defualt language will same to your local language (only support english or chinese). but you can custom like yourself.
If your language is english or chinese, you will not need setup all property, empty property will auto fill same to your local language.

```objc
@interface SHDateLanguageModel : NSObject

@property (nonatomic, strong) NSString *today;
@property (nonatomic, strong) NSString *tomorrow;
@property (nonatomic, strong) NSString *hour;
@property (nonatomic, strong) NSString *minute;

@property (nonatomic, strong) NSString *done;
@property (nonatomic, strong) NSString *cancel;

```
## Requirements

* iOS 8.0+ 
* ARC

## Author

@harushuu, hunter4n@gmail.com

## License

English: SHDatePicker is available under the MIT license, see the LICENSE file for more information.     

