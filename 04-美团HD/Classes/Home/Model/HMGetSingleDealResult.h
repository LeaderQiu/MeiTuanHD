//
//  HMGetSingleDealResult.h
//  04-美团HD
//
//  Created by apple on 15/2/8.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMGetSingleDealResult : NSObject
/** 本次团购数据（里面都是HMDeal模型） */
@property (nonatomic, strong) NSArray *deals;
@end
