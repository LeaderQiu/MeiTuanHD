//
//  HMDealTool.m
//  04-美团HD
//
//  Created by apple on 15/2/8.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "HMDealTool.h"
#import "HMDeal.h"

/** 最大的历史记录个数 */
static int const HMMaxHistoryDealsCount = 9;

#define HMCollectFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"collect_deals.data"]

#define HMHistoryFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"history_deals.data"]

@implementation HMDealTool

/** 被收藏的团购数据 */
static NSMutableArray *_collectedDeals;
/** 历史访问的团购数据 */
static NSMutableArray *_historyDeals;
+ (void)initialize
{
    // 从文件中读取之前收藏的团购
    _collectedDeals = [NSKeyedUnarchiver unarchiveObjectWithFile:HMCollectFile];
    if (_collectedDeals == nil) {
        _collectedDeals = [NSMutableArray array];
    }
    // 从文件中读取之前访问的团购
    _historyDeals = [NSKeyedUnarchiver unarchiveObjectWithFile:HMHistoryFile];
    if (_historyDeals == nil) {
        _historyDeals = [NSMutableArray array];
    }
}

#pragma mark - 收藏
+ (NSArray *)collectedDeals
{
    return _collectedDeals;
}

+ (BOOL)isCollected:(HMDeal *)deal
{
    return [_collectedDeals containsObject:deal];
}

+ (void)collect:(HMDeal *)deal
{
    [_collectedDeals insertObject:deal atIndex:0];
    [NSKeyedArchiver archiveRootObject:_collectedDeals toFile:HMCollectFile];
}

+ (void)uncollect:(HMDeal *)deal
{
    [_collectedDeals removeObject:deal];
    [NSKeyedArchiver archiveRootObject:_collectedDeals toFile:HMCollectFile];
}

+ (void)uncollectDeals:(NSArray *)deals
{
    [_collectedDeals removeObjectsInArray:deals];
    [NSKeyedArchiver archiveRootObject:_collectedDeals toFile:HMCollectFile];
}

#pragma mark - 历史记录
/**
 *  返回用户访问的所有团购
 */
+ (NSArray *)historyDeals
{
    return _historyDeals;
}

/**
 *  添加一个最近访问团购
 */
+ (void)addHistoryDeal:(HMDeal *)deal
{
    // 添加
    [_historyDeals removeObject:deal];
    [_historyDeals insertObject:deal atIndex:0];
    
    // 删除最后一个团购
    if (_historyDeals.count > HMMaxHistoryDealsCount) {
        [_historyDeals removeLastObject];
    }
    
    [NSKeyedArchiver archiveRootObject:_historyDeals toFile:HMHistoryFile];
}

/**
 *  删除最近访问的团购
 */
+ (void)removeHistoryDeal:(HMDeal *)deal
{
    [_historyDeals removeObject:deal];
    [NSKeyedArchiver archiveRootObject:_historyDeals toFile:HMHistoryFile];
}

+ (void)removeHistoryDeals:(NSArray *)deals
{
    [_historyDeals removeObjectsInArray:deals];
    [NSKeyedArchiver archiveRootObject:_historyDeals toFile:HMHistoryFile];
}
@end
