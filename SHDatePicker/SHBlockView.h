//
//  SHBlockView.h
//  SHDatePicker
//
//  Created by shuu on 7/10/16.
//  Copyright (c) 2016 @harushuu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SHBlockViewWillDidmissBlock)(void);


@interface SHBlockView : UIView
@property (nonatomic, copy) SHBlockViewWillDidmissBlock willDismissBlockView;

+ (SHBlockView *)sharedView;

@end
