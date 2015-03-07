//
//  HMCenterLineLabel.m
//  04-美团HD
//
//  Created by apple on 15/2/5.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "HMCenterLineLabel.h"

@implementation HMCenterLineLabel

- (void)drawRect:(CGRect)rect
{
    // 调用super的目的，保留之前绘制的文字
    [super drawRect:rect];
    
    // 画线
    CGFloat x = 0 + rect.origin.x;
    CGFloat y = rect.size.height * 0.5 + rect.origin.y;
    CGFloat w = rect.size.width;
    CGFloat h = 1;
    UIRectFill(CGRectMake(x, y, w, h));
}

@end
