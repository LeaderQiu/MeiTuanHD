//
//  HMCity.m
//  04-美团HD
//
//  Created by apple on 15/2/5.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "HMCity.h"
#import "HMDistrict.h"

@implementation HMCity

+ (NSDictionary *)objectClassInArray
{
    return @{@"districts" : [HMDistrict class]};
}

@end
