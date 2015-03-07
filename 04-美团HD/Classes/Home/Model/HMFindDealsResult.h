//
//  HMFindDealsResult.h
//  04-美团HD
//
//  Created by apple on 15/2/5.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMFindDealsResult : NSObject
/** 所有团购总数 */
@property (nonatomic, assign) int total_count;
/** 本次团购数据（里面都是HMDeal模型） */
@property (nonatomic, strong) NSArray *deals;
@end
