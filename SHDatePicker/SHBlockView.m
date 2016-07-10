//
//  SHBlockView.m
//  SHDatePicker
//
//  Created by shuu on 7/10/16.
//  Copyright (c) 2016 @harushuu. All rights reserved.
//

#import "SHBlockView.h"
#import <Masonry/Masonry.h>

@implementation SHBlockView

# pragma mark - initialization

+ (SHBlockView *)sharedView {
    static SHBlockView *sharedView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedView = [[[self class] alloc] init];
    });
    return sharedView;
}

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor darkGrayColor];
        self.alpha = 0.6;
        self.hidden = YES;
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        [window addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(window);
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGeatureHandle)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

# pragma mark - private API

- (void)tapGeatureHandle {
    if (self.willDismissBlockView) self.willDismissBlockView();
}

@end
