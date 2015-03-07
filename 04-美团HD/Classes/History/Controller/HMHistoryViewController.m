//
//  HMHistoryViewController.m
//  04-美团HD
//
//  Created by apple on 15/2/8.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "HMHistoryViewController.h"
#import "HMDealTool.h"

@interface HMHistoryViewController ()
@end

@implementation HMHistoryViewController

- (NSString *)noDataImageName
{
    UIViewContentMode;
    return @"icon_latestBrowse_empty";
}

#pragma mark - 初始化
- (NSString *)title
{
    return @"浏览记录";
}

- (NSArray *)totalDeals
{
    return [HMDealTool historyDeals];
}

- (void)deleteLocalDeals:(NSArray *)deletedDeals
{
    [HMDealTool removeHistoryDeals:deletedDeals];
}
@end
