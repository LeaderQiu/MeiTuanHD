//
//  HMDealTool.h
//  04-美团HD
//
//  Created by apple on 15/2/8.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HMDeal;

@interface HMDealTool : NSObject
/**
 *  返回用户收藏的所有团购
 */
+ (NSArray *)collectedDeals;

/**
 *  判断某个团购是否被收藏
 */
+ (BOOL)isCollected:(HMDeal *)deal;

/**
 *  收藏团购
 */
+ (void)collect:(HMDeal *)deal;

/**
 *  取消收藏团购
 */
+ (void)uncollect:(HMDeal *)deal;
+ (void)uncollectDeals:(NSArray *)deals;

/**
 *  返回用户访问的所有团购
 */
+ (NSArray *)historyDeals;

/**
 *  添加一个最近访问团购
 */
+ (void)addHistoryDeal:(HMDeal *)deal;

/**
 *  删除最近访问的团购
 */
+ (void)removeHistoryDeal:(HMDeal *)deal;
+ (void)removeHistoryDeals:(NSArray *)deals;
@end
