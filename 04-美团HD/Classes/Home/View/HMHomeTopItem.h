//
//  HMHomeTopItem.h
//  美团HD
//
//  Created by apple on 14/11/23.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMHomeTopItem : UIView
+ (instancetype)item;

- (void)setTitle:(NSString *)title;
- (void)setSubtitle:(NSString *)subtitle;
- (void)setIcon:(NSString *)icon highIcon:(NSString *)highIcon;

- (void)addTarget:(id)target action:(SEL)action;
@end
