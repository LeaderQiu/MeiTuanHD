//
//  HMCollectViewController.m
//  04-美团HD
//
//  Created by apple on 15/2/8.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "HMCollectViewController.h"
#import "HMDealTool.h"

@interface HMCollectViewController ()
@end

@implementation HMCollectViewController

- (NSString *)noDataImageName
{
    return @"icon_collects_empty";
}

#pragma mark - 初始化
- (NSString *)title
{
    return @"我的收藏";
}

- (NSArray *)totalDeals
{
    return [HMDealTool collectedDeals];
}

- (void)deleteLocalDeals:(NSArray *)deletedDeals
{
    [HMDealTool uncollectDeals:deletedDeals];
}
@end
