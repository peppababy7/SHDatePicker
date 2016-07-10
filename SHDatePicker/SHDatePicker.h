//
//  SHDatePicker.h
//  SHDatePicker
//
//  Created by shuu on 7/10/16.
//  Copyright (c) 2016 @harushuu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SHDatePickerCompleteHandle)(NSDate *selectedDate, NSString *dateString);

@interface SHDatePicker : UIView

//  First init and calculate default datasource only need 95ms. So do not worry about performance

//  default dayCount is 7 days;
//  default minuteInterval is 5 minutes;
//  default firstMinuteInterval is 5 * 60 secend;
- (instancetype)initWithCompleteHandle:(SHDatePickerCompleteHandle)completeHandle;

// custom
- (instancetype)initWithDefaultDayCount:(NSInteger)dayCount minuteInterval:(NSInteger)minuteInterval firstMinuteInterval:(NSInteger)firstMinuteInterval completeHandle:(SHDatePickerCompleteHandle)completeHandle;

- (void)updateHiddenStatus;

- (void)updateDatePickerDataSource;

@end
