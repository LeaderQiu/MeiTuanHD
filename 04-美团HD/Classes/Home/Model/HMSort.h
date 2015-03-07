//
//  HMSort.h
//  04-美团HD
//
//  Created by apple on 15/2/4.
//  Copyright (c) 2015年 heima. All rights reserved.
//  排序模型

#import <Foundation/Foundation.h>

@interface HMSort : NSObject
/** 文字描述 */
@property (nonatomic, copy) NSString *label;
/** 这个排序具体的值（将来发给服务器） */
@property (nonatomic, assign) int value;
@end
