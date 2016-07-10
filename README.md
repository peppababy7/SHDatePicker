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

default

    default dayCount is 7 days;
    default minuteInterval is 5 minutes;
    default firstMinuteInterval is 5 * 60 secend;

```objc
    - (instancetype)initWithCompleteHandle:(SHDatePickerCompleteHandle)completeHandle;
```

custom

```objc
- (instancetype)initWithDefaultDayCount:(NSInteger)dayCount minuteInterval:(NSInteger)minuteInterval firstMinuteInterval:(NSInteger)firstMinuteInterval completeHandle:(SHDatePickerCompleteHandle)completeHandle;
```

## Requirements

* iOS 8.0+ 
* ARC

## Author

@harushuu, hunter4n@gmail.com

## License

English: SHDatePicker is available under the MIT license, see the LICENSE file for more information.     

