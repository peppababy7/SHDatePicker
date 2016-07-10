# SHGuideView

[![CI Status](http://img.shields.io/travis/@harushuu/SHGuideView.svg?style=flat)](https://travis-ci.org/@harushuu/SHGuideView)
[![Version](https://img.shields.io/cocoapods/v/SHGuideView.svg?style=flat)](http://cocoapods.org/pods/SHGuideView)
[![License](https://img.shields.io/cocoapods/l/SHGuideView.svg?style=flat)](http://cocoapods.org/pods/SHGuideView)
[![Platform](https://img.shields.io/cocoapods/p/SHGuideView.svg?style=flat)](http://cocoapods.org/pods/SHGuideView)

## Screenshots
![image](https://github.com/harushuu/SHGuideView/raw/master/Screenshots.gif)

## Installation

With [CocoaPods](http://cocoapods.org/), add this line to your `Podfile`.

```
pod 'SHGuideView'
```

and run `pod install`, then you're all done!

## How to use

```objc
    if ([SHGuideViewController needShowGuidePage]) {
            SHGuideViewController *guideViewController = [[SHGuideViewController alloc] initWithImageName:@"Guide" guidePage:3 completeHandle:^{
            //code... push your view controller;
        }];
        self.window.rootViewController = guideViewController;
    } else {
        //code... push your view controller;
    }
```

## Summary

A simple guide viewController.

Just need set imageName and page count, then implement block functionality using your code please.

Please rename your guide image with format:

    e.g.
    yourImageName == 'Guide'
    yourImageTotalCount == 3

    your guide image with IPhone4S resolution:
    Please rename your image with  :  'Guide_IPhone4S_1'
    Please rename your image with  :  'Guide_IPhone4S_2'
    Please rename your image with  :  'Guide_IPhone4S_3'

    your guide image with IPhone5 resolution
    Please rename your image with  :  'Guide_IPhone5_1'
    Please rename your image with  :  'Guide_IPhone5_2'
    Please rename your image with  :  'Guide_IPhone5_3'

    your guide image with IPhone6 resolution
    Please rename your image with  :  'Guide_IPhone6_1'
    Please rename your image with  :  'Guide_IPhone6_2'
    Please rename your image with  :  'Guide_IPhone6_3'

    your guide image with IPhone6P resolution
    Please rename your image with  :  'Guide_IPhone6P_1'
    Please rename your image with  :  'Guide_IPhone6P_2'
    Please rename your image with  :  'Guide_IPhone6P_3'

## Requirements

* iOS 8.0+ 
* ARC

## Author

@harushuu, hunter4n@gmail.com

## License

English: SHTabbarController is available under the MIT license, see the LICENSE file for more information.     

