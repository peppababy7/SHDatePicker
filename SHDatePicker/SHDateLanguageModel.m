//
//  SHDateLanguageModel.m
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


#import "SHDateLanguageModel.h"
#import <objc/runtime.h>

@implementation SHDateLanguageModel

+ (SHDateLanguageModel *)updateWithDataSource:(SHDateLanguageModel *)dataSource {
    SHDateLanguageModel *languageModel = [SHDateLanguageModel currentLocationLanguage];
    return !dataSource ? languageModel : [languageModel updateDate:dataSource];
}

+ (SHDateLanguageModel *)currentLocationLanguage {
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    SHDateLanguageModel *languageModel = [[SHDateLanguageModel alloc] init];
    BOOL isEnglish = ![SHDateLanguageModel currentLanguagesIsChinses];
    languageModel.today = isEnglish ? @"today" : @"今天";
    languageModel.tomorrow = isEnglish ? @"tomorrow" : @"明天";
    languageModel.hour = isEnglish ? @"h" : @"时";
    languageModel.minute = isEnglish ? @"min" : @"分";
    languageModel.done = isEnglish ? @"done" : @"确定";
    languageModel.cancel = isEnglish ? @"cancel" : @"取消";
    return languageModel;
}

+ (NSLocale *)currentLocale {
    if ([SHDateLanguageModel currentLanguagesIsChinses]) {
        
    }
    NSString *localeIdentifier = ![SHDateLanguageModel currentLanguagesIsChinses] ? @"en_US" : @"zh-Hans";
    NSLocale *currentLocale = [[NSLocale alloc] initWithLocaleIdentifier:localeIdentifier];
    return currentLocale;
}

+ (BOOL)currentLanguagesIsChinses {
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    return [currentLanguage containsString:@"zh"];
}

- (SHDateLanguageModel *)updateDate:(SHDateLanguageModel *)date {
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *char_f = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        NSString *propertyValue = [date valueForKey:(NSString *)propertyName];
        if (propertyValue.length) {
            [self setValue:propertyValue forKey:(NSString *)propertyName];
        }
    }
    free(properties);
    return self;
}

@end
