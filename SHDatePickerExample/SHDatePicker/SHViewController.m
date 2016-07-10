//
//  SHViewController.m
//  SHDatePicker
//
//  Created by @harushuu on 07/10/2016.
//  Copyright (c) 2016 @harushuu. All rights reserved.
//

#import "SHViewController.h"
#import "SHDatePicker.h"

@interface SHViewController ()
@property (nonatomic, strong) UIButton *datePickerButton;
@property (nonatomic, strong) UILabel *selectedDateStringLabel;
@property (nonatomic, strong) UILabel *selectedDateLabel;

@end

@implementation SHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.datePickerButton];
    [self.view addSubview:self.selectedDateStringLabel];
    [self.view addSubview:self.selectedDateLabel];
}



- (void)pushDatePicker {
    SHDatePicker *datePicker = [[SHDatePicker alloc] initWithCompleteHandle:^(NSDate *selectedDate, NSString *dateString) {
        NSLog(@"selectedDate--%@",selectedDate);
        NSLog(@"dateString--%@",dateString);
        self.selectedDateLabel.text = [NSString stringWithFormat:@"%@", selectedDate];
        self.selectedDateStringLabel.text = dateString;
        
    }];
    [datePicker updateHiddenStatus];
}

- (UIButton *)datePickerButton {
    if (!_datePickerButton) {
        _datePickerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        [_datePickerButton setTitle:@"push date picker" forState:UIControlStateNormal];
        _datePickerButton.backgroundColor = [UIColor lightGrayColor];
        _datePickerButton.center = self.view.center;
        [_datePickerButton addTarget:self action:@selector(pushDatePicker) forControlEvents:UIControlEventTouchUpInside];
    }
    return _datePickerButton;
}

- (UILabel *)selectedDateLabel {
    if (!_selectedDateLabel) {
        _selectedDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.datePickerButton.frame) + 40, [UIScreen mainScreen].bounds.size.width, 40)];
        _selectedDateLabel.text = @"Selected Date";
        _selectedDateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _selectedDateLabel;
}

- (UILabel *)selectedDateStringLabel {
    if (!_selectedDateStringLabel) {
        _selectedDateStringLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.selectedDateLabel.frame) + 20, [UIScreen mainScreen].bounds.size.width, 40)];
        _selectedDateStringLabel.text = @"Selected Date String";
        _selectedDateStringLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _selectedDateStringLabel;
}

@end
