//
//  HMGetSingleDealResult.m
//  04-美团HD
//
//  Created by apple on 15/2/8.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "HMGetSingleDealResult.h"
#import "HMDeal.h"

@implementation HMGetSingleDealResult
+ (NSDictionary *)objectClassInArray
{
    return @{@"deals" : [HMDeal class]};
}
@end