//
//  SHDatePicker.m
//  SHDatePicker
//
//  Created by shuu on 7/10/16.
//  Copyright (c) 2016 @harushuu. All rights reserved.
//

#import "SHDatePicker.h"
#import "SHBlockView.h"
#import <Masonry/Masonry.h>

static NSInteger const kDefaultDayCount = 7;
static NSInteger const kDefaultMinuteInterval = 5;
#define SCREEN_WINDOW [[[UIApplication sharedApplication] delegate] window]

@interface SHDatePicker () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, strong) UIPickerView *datePicker;
@property (nonatomic, strong) UIView *topToolsView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) SHBlockView *blockView;
@property (nonatomic, strong) NSDate *compareDate;
@property (nonatomic, strong) NSMutableArray *fullDateSource;
@property (nonatomic, strong) NSMutableArray *currentHourDateSource;
@property (nonatomic, strong) NSMutableArray *showDateSource;
@property (nonatomic, assign) NSInteger oldHoursRow;
@property (nonatomic, assign) NSInteger oldMinuteRow;
@property (nonatomic, assign) NSInteger defaultDayCount;
@property (nonatomic, assign) NSInteger defaultMinuteInterval;
@property (nonatomic, assign) NSInteger firstMinuteInterval;
@property (nonatomic, copy) SHDatePickerCompleteHandle completeHandle;
@end

@implementation SHDatePicker

# pragma mark - initialization

- (instancetype)initWithCompleteHandle:(SHDatePickerCompleteHandle)completeHandle {
    if (self = [super init]) {
        if (completeHandle) {
            self.completeHandle = completeHandle;
        }
        self.defaultDayCount = kDefaultDayCount;
        self.defaultMinuteInterval = kDefaultMinuteInterval;
        self.firstMinuteInterval = self.defaultMinuteInterval * 60;
        self.backgroundColor = [UIColor whiteColor];
        [self updateDatePickerDataSource];
        [self setupViews];
        self.hidden = YES;
        [self updateConstraintsIfNeeded];
        [self setNeedsUpdateConstraints];
        [self layoutIfNeeded];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(SCREEN_WINDOW);
            make.height.mas_equalTo(1);
        }];
        [self updateConstraintsIfNeeded];
        [self setNeedsUpdateConstraints];
        [self layoutIfNeeded];
    }
    return self;
}

- (instancetype)initWithDefaultDayCount:(NSInteger)dayCount minuteInterval:(NSInteger)minuteInterval firstMinuteInterval:(NSInteger)firstMinuteInterval completeHandle:(SHDatePickerCompleteHandle)completeHandle {
    if (self = [super init]) {
        if (completeHandle) {
            self.completeHandle = completeHandle;
        }
        self.defaultDayCount = dayCount ? : kDefaultDayCount;
        self.defaultMinuteInterval = minuteInterval ? : kDefaultMinuteInterval;
        self.firstMinuteInterval = firstMinuteInterval ? : self.defaultMinuteInterval * 60;
        self.backgroundColor = [UIColor whiteColor];
        [self updateDatePickerDataSource];
        [self setupViews];
        self.hidden = YES;
        [self updateConstraintsIfNeeded];
        [self setNeedsUpdateConstraints];
        [self layoutIfNeeded];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(SCREEN_WINDOW);
            make.height.mas_equalTo(1);
        }];
        [self updateConstraintsIfNeeded];
        [self setNeedsUpdateConstraints];
        [self layoutIfNeeded];
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.topToolsView];
    [self addSubview:self.datePicker];
    [self.topToolsView addSubview:self.cancelButton];
    [self.topToolsView addSubview:self.doneButton];
    [SCREEN_WINDOW addSubview:self];
}

- (void)updateConstraints {
    if (!self.didSetupConstraints) {
        self.didSetupConstraints = YES;
        [self.topToolsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(38);
        }];
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.topToolsView);
            make.left.equalTo(self.topToolsView).with.offset(20);
            make.size.mas_equalTo(CGSizeMake(40, 38));
        }];
        [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.topToolsView);
            make.right.equalTo(self.topToolsView).with.offset(-20);
            make.size.mas_equalTo(CGSizeMake(40, 38));
        }];
        [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.mas_equalTo(self.topToolsView.mas_bottom);
            make.height.mas_equalTo(162);
        }];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(SCREEN_WINDOW);
            make.height.mas_equalTo(200);
        }];
    }
    [super updateConstraints];
}

# pragma mark - private API

- (void)buttonPressed:(UIButton *)button {
    if (button == self.doneButton) {
        if (self.completeHandle) {
            NSInteger dayCount = [self.datePicker selectedRowInComponent:0];
            NSInteger hourCount = [self.datePicker selectedRowInComponent:1];
            NSInteger minuteCount = [self.datePicker selectedRowInComponent:2];
            NSString *dayString = self.showDateSource[0][dayCount];
            NSString *hourString = self.showDateSource[1][hourCount];
            NSString *minuteString = self.showDateSource[2][minuteCount];
            hourString = [hourString substringWithRange:NSMakeRange(0, hourString.length - 1)];
            minuteString = [minuteString substringWithRange:NSMakeRange(0, minuteString.length - 3)];
            if (hourString.length == 1) hourString = [@"0" stringByAppendingString:hourString];
            if (minuteString.length == 1) minuteString = [@"0" stringByAppendingString:minuteString];
            NSString *dateString = [NSString stringWithFormat:@"%@ %@:%@",dayString, hourString, minuteString];
            if (!dayCount) {
                if (!hourCount) {
                    minuteCount = 60 / self.defaultMinuteInterval - [self.showDateSource[2] count] + minuteCount;
                }
                hourCount = 24 - [self.showDateSource[1] count] + hourCount;
            }
            NSDate *zeroHourDate = [self dateRoundedDownToTime:60 * 60 * 24 withDate:self.compareDate];
            if ([self.showDateSource[0][0] isEqualToString:@"Tomorrow"]) dayCount = dayCount + 1;
            NSDate *selectedDate = [NSDate dateWithTimeInterval:dayCount * 24 * 3600 + hourCount * 3600 + minuteCount * 60 * self.defaultMinuteInterval  sinceDate:zeroHourDate];
            selectedDate = [self getUTCTimeIntervalWithDate:selectedDate];
            self.completeHandle(selectedDate, dateString);
        }
    }
    [self updateHiddenStatus];
}

- (void)updateHiddenStatus {
    if (self.hidden) {
        [self updateDatePickerDataSource];
    }
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.isHidden ? 200 : 1);
    }];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    if (self.isHidden) {
        self.hidden = !self.isHidden;
        self.blockView.hidden = !self.blockView.isHidden;
        typeof(self) __weak weakSelf = self;
        self.blockView.willDismissBlockView = ^(){
            [weakSelf updateHiddenStatus];
        };
        [[[[UIApplication sharedApplication] delegate] window] bringSubviewToFront:self];
        self.alpha = 0.01;
        self.blockView.alpha = 0.01;
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 1;
            self.blockView.alpha = 0.6;
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0.01;
            self.blockView.alpha = 0.01;
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.hidden = !self.isHidden;
            self.blockView.hidden = !self.blockView.isHidden;
            self.blockView.willDismissBlockView = nil;
        }];
    }
}

- (void)updateDatePickerDataSource {
    NSDate *currentDate = [self getSystemTimeZoneDate];
    NSDate *currentDateRoundedDown;
    NSDate *compareDateRoundedDown;
    if (self.compareDate) {
        currentDateRoundedDown = [NSDate dateWithTimeInterval:self.firstMinuteInterval sinceDate:currentDate];
        compareDateRoundedDown = [NSDate dateWithTimeInterval:self.firstMinuteInterval sinceDate:self.compareDate];
        int currentTime = (int)[currentDateRoundedDown timeIntervalSinceReferenceDate];
        int compareTime = (int)[compareDateRoundedDown timeIntervalSinceReferenceDate];
        if (currentTime - compareTime < 60 * self.defaultMinuteInterval && currentTime != compareTime) {
            [self defaultDatePickerStatus];
            return;
        }
    }
    if (!self.compareDate) {
        self.compareDate = currentDateRoundedDown ? currentDateRoundedDown : [NSDate dateWithTimeInterval:self.firstMinuteInterval sinceDate:currentDate];
        NSMutableArray *daysArray = [NSMutableArray arrayWithCapacity:self.defaultDayCount];
        NSMutableArray *hoursArray = [NSMutableArray arrayWithCapacity:24];
        NSMutableArray *minutesArray = [NSMutableArray arrayWithCapacity:60 / self.defaultMinuteInterval];
        daysArray = [self getDayArray];
        for (int i = 0; i < 24; i++) {
            [hoursArray addObject:[NSString stringWithFormat:@"%dh",i]];
        }
        for (int i = 0; i < 60 / self.defaultMinuteInterval; i++) {
            [minutesArray addObject:[NSString stringWithFormat:@"%dmin", i * (int)self.defaultMinuteInterval]];
        }
        self.fullDateSource = [NSMutableArray arrayWithObjects:daysArray, hoursArray, minutesArray, nil];
        self.showDateSource = [self.fullDateSource mutableCopy];
    }
    NSMutableArray *currentHoursArray = [self.fullDateSource[1] mutableCopy];
    NSMutableArray *currentMinutesArray = [self.fullDateSource[2] mutableCopy];
    NSDate *zeroHourDate = [self dateRoundedDownToTime:60 * 60 * 24 withDate:self.compareDate];
    int passedHours = [self getPassedTimeCountWithDate:self.compareDate zeroClockDate:zeroHourDate timeInterval:3600];
    [currentHoursArray removeObjectsInRange:NSMakeRange(0, passedHours)];
    int passedMinutes = [self getPassedTimeCountWithDate:self.compareDate zeroClockDate:[NSDate dateWithTimeInterval:3600 * passedHours sinceDate:zeroHourDate] timeInterval:60 * self.defaultMinuteInterval];
    [currentMinutesArray removeObjectsInRange:NSMakeRange(0, passedMinutes + 1)];
    if (passedMinutes == 60 / self.defaultMinuteInterval - 1) {
        [currentHoursArray removeObjectAtIndex:0];
    }
    if (!currentMinutesArray.count) {
        currentMinutesArray = [self.fullDateSource[2] mutableCopy];
    }
    self.currentHourDateSource = [NSMutableArray arrayWithObjects:currentHoursArray, currentMinutesArray, nil];
    self.showDateSource = [NSMutableArray arrayWithObjects:self.showDateSource[0], currentHoursArray, currentMinutesArray, nil];
    NSMutableArray *daysArray = [self.fullDateSource[0] mutableCopy];
    [daysArray removeLastObject];
    [self.showDateSource replaceObjectAtIndex:0 withObject:daysArray];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"d"];
    BOOL needupdate = [[formatter stringFromDate:[NSDate dateWithTimeInterval:- 8 * 3600 sinceDate:currentDate]] isEqualToString:[formatter stringFromDate:[NSDate dateWithTimeInterval:-60 * self.defaultMinuteInterval - 8 * 3600 sinceDate:self.compareDate]]];
    if (!passedHours && !passedMinutes) {
        if (needupdate) {
            NSMutableArray *daysArray = [self.fullDateSource[0] mutableCopy];
            [daysArray removeObjectAtIndex:0];
            [self.showDateSource replaceObjectAtIndex:0 withObject:daysArray];
        }
        BOOL needupdate1 = [[formatter stringFromDate:[NSDate dateWithTimeInterval:- 8 * 3600 sinceDate:currentDate]] isEqualToString:[formatter stringFromDate:[NSDate dateWithTimeInterval:60 * self.defaultMinuteInterval - 8 * 3600 sinceDate:currentDate]]];
        if (!needupdate1) {
            NSMutableArray *minitsArray1 = [self.fullDateSource[2] mutableCopy];
            [self.showDateSource replaceObjectAtIndex:2 withObject:minitsArray1];
        }
    }
    self.compareDate = compareDateRoundedDown ? compareDateRoundedDown : [NSDate dateWithTimeInterval:self.firstMinuteInterval sinceDate:currentDate];
    [self.datePicker reloadAllComponents];
    [self defaultDatePickerStatus];
}

- (void)defaultDatePickerStatus {
    if ([self.showDateSource[1] count] != [self.currentHourDateSource[0] count]) {
        [self.showDateSource replaceObjectAtIndex:1 withObject:self.currentHourDateSource[0]];
        [self.datePicker reloadComponent:1];
    }
    if ([self.showDateSource[2] count] != [self.currentHourDateSource[1] count]) {
        [self.showDateSource replaceObjectAtIndex:2 withObject:self.currentHourDateSource[1]];
        [self.datePicker reloadComponent:2];
    }
    [self.datePicker selectRow:0 inComponent:0 animated:NO];
    [self.datePicker selectRow:0 inComponent:1 animated:NO];
    [self.datePicker selectRow:0 inComponent:2 animated:NO];
    self.oldHoursRow = 0;
    self.oldMinuteRow = 0;
}

- (NSMutableArray *)getDayArray {
    NSMutableArray *daysArray = [NSMutableArray arrayWithCapacity:self.defaultDayCount];
    for (int i = 0; i < self.defaultDayCount + 1; i++) {
        if (!i) {
            [daysArray addObject:@"Today"];
        } else if (i == 1) {
            [daysArray addObject:@"Tomorrow"];
        } else {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.locale = [NSLocale systemLocale];
            [formatter setDateFormat:@"M-d EEE"];
            [daysArray addObject:[formatter stringFromDate:[NSDate dateWithTimeInterval:(NSTimeInterval)i * 60 * 60 * 24 sinceDate:[self dateRoundedDownToTime:60 * 60 * 24 withDate:self.compareDate]]]];
        }
    }
    return daysArray;
}

# pragma mark - DateTools

- (int)getPassedTimeCountWithDate:(NSDate *)currentDate zeroClockDate:(NSDate *)zeroClockDate timeInterval:(NSInteger)timeInterval {
    int referenceTimeInterval = (int)[currentDate timeIntervalSinceDate:zeroClockDate];
    int passedTimeCount = referenceTimeInterval / timeInterval;
    return passedTimeCount;
}

- (NSDate *)dateRoundedDownToTime:(NSInteger)time withDate:(NSDate *)date {
    NSInteger referenceTimeInterval = [date timeIntervalSinceReferenceDate];
    NSInteger remainingSeconds = referenceTimeInterval % time;
    NSInteger timeRoundedTo5Minutes = referenceTimeInterval - remainingSeconds;
    if (time != 60 * 60 * 24) timeRoundedTo5Minutes = referenceTimeInterval +(time - remainingSeconds);
    NSDate *roundedDate = [NSDate dateWithTimeIntervalSinceReferenceDate:(NSTimeInterval)timeRoundedTo5Minutes];
    return roundedDate;
}

- (NSDate *)getSystemTimeZoneDate {
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
    return localeDate;
}

- (NSDate *)getUTCTimeIntervalWithDate:(NSDate *)date {
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date dateByAddingTimeInterval:-interval];
    return localeDate;
}

# pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (!component) {
        NSInteger oldHoursCount = [self.showDateSource[1] count];
        [self.showDateSource replaceObjectAtIndex:1 withObject:!row ? self.currentHourDateSource[0] : self.fullDateSource[1]];
        [pickerView reloadComponent:1];
        NSInteger newHoursCount = [self.showDateSource[1] count];
        if (oldHoursCount > newHoursCount) {
            NSInteger hourDelta = (oldHoursCount - self.oldHoursRow) - (newHoursCount - row);
            if (hourDelta <= 0) {
                NSInteger newHourRow = newHoursCount - (oldHoursCount - self.oldHoursRow);
                [pickerView selectRow:newHourRow inComponent:1 animated:NO];
                self.oldHoursRow = newHourRow;
            } else {
                [pickerView selectRow:0 inComponent:1 animated:NO];
                self.oldHoursRow = 0;
            }
        } else if (oldHoursCount < newHoursCount) {
            NSInteger newHourRow = newHoursCount - (oldHoursCount - self.oldHoursRow);
            [pickerView selectRow:newHourRow inComponent:1 animated:NO];
            self.oldHoursRow = newHourRow;
        }
        [self.datePicker.delegate pickerView:self.datePicker didSelectRow:self.oldHoursRow inComponent:1];
    } else if (component == 1) {
        NSInteger oldMinutesCount = [self.showDateSource[2] count];
        [self.showDateSource replaceObjectAtIndex:2 withObject:(!row && ![pickerView selectedRowInComponent:0]) ? self.currentHourDateSource[1] : self.fullDateSource[2]];
        [pickerView reloadComponent:2];
        NSInteger newMinutesCount = [self.showDateSource[2] count];
        if (oldMinutesCount > newMinutesCount) {
            NSInteger minuteDelta = (oldMinutesCount - self.oldMinuteRow) - (newMinutesCount - row);
            if (minuteDelta <= 0) {
                NSInteger newMinuteRow = newMinutesCount - (oldMinutesCount - self.oldMinuteRow);
                [pickerView selectRow:newMinuteRow inComponent:2 animated:NO];
                self.oldMinuteRow = newMinuteRow;
            } else {
                [pickerView selectRow:0 inComponent:2 animated:NO];
                self.oldMinuteRow = 0;
            }
        } else if (oldMinutesCount < newMinutesCount) {
            NSInteger newMinuteRow = newMinutesCount - (oldMinutesCount - self.oldMinuteRow);
            [pickerView selectRow:newMinuteRow inComponent:2 animated:NO];
            self.oldMinuteRow = newMinuteRow;
        }
        self.oldHoursRow = row;
    } else {
        self.oldMinuteRow = row;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.font = [UIFont boldSystemFontOfSize:15.f];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.text = self.showDateSource[component][row];
    return contentLabel;
}

# pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.showDateSource[component] count];
}

# pragma mark - lazyload

- (UIPickerView *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIPickerView alloc] init];
        _datePicker.delegate = self;
        _datePicker.dataSource = self;
    }
    return _datePicker;
}

- (UIView *)topToolsView {
    if (!_topToolsView) {
        _topToolsView = [[UIView alloc] init];
    }
    return _topToolsView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
        _cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _cancelButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_cancelButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [[UIButton alloc] init];
        [_doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
        _doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _doneButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_doneButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}

- (SHBlockView *)blockView {
    if (!_blockView) {
        _blockView = [SHBlockView sharedView];
    }
    return _blockView;
}

- (NSMutableArray *)currentHourDateSource {
    if (!_currentHourDateSource) {
        _currentHourDateSource = [NSMutableArray array];
    }
    return _currentHourDateSource;
}

- (NSMutableArray *)fullDateSource {
    if (!_fullDateSource) {
        _fullDateSource = [NSMutableArray array];
    }
    return _fullDateSource;
}

- (NSMutableArray *)showDateSource {
    if (!_showDateSource) {
        _showDateSource = [NSMutableArray array];
    }
    return _showDateSource;
}
@end
