//
//  HMDeal.m
//  04-美团HD
//
//  Created by apple on 15/2/5.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "HMDeal.h"
#import <MJExtension.h>
#import "NSString+Extension.h"

@implementation HMDeal

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"desc" : @"description",
             @"is_refundable" : @"restrictions.is_refundable"};
}

- (void)setList_price:(NSString *)list_price
{
    _list_price = list_price.dealedPriceString;
}

- (void)setCurrent_price:(NSString *)current_price
{
    _current_price = current_price.dealedPriceString;
}

/**
 *  这个方法的作用：比较self和other是否为同一个对象
 */
- (BOOL)isEqual:(HMDeal *)other
{
    return [self.deal_id isEqualToString:other.deal_id];
}

#pragma mark - <NSCoding>
MJCodingImplementation
@end
