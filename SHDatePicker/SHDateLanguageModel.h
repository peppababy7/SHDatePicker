//
//  SHDateLanguageModel.h
//  Pods
//
//  Created by shuu on 7/31/16.
//  Copyright (c) 2016 @harushuu. All rights reserved.
//
// The MIT License (MIT)
//
// Copyright (c) 2016 @harushuu
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#import <Foundation/Foundation.h>

@interface SHDateLanguageModel : NSObject

// defualt language will same to your local language (only support english or chinese). but you can custom like yourself.
// if your language is english or chinese, you will not need setup all property, empty property will auto fill same to your local language.

@property (nonatomic, strong) NSString *today;
@property (nonatomic, strong) NSString *tomorrow;
@property (nonatomic, strong) NSString *hour;
@property (nonatomic, strong) NSString *minute;

@property (nonatomic, strong) NSString *done;
@property (nonatomic, strong) NSString *cancel;

+ (SHDateLanguageModel *)currentLocationLanguage;

+ (SHDateLanguageModel *)updateWithDataSource:(SHDateLanguageModel *)dataSource;

+ (NSLocale *)currentLocale;

@end
