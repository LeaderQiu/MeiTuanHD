//
//  HMFindDealsResult.m
//  04-美团HD
//
//  Created by apple on 15/2/5.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "HMFindDealsResult.h"
#import "HMDeal.h"

@implementation HMFindDealsResult
+ (NSDictionary *)objectClassInArray
{
    return @{@"deals" : [HMDeal class]};
}
@end
