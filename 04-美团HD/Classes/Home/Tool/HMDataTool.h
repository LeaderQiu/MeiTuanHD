//
//  HMDataTool.h
//  04-美团HD
//
//  Created by apple on 15/2/4.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HMCity;

@interface HMDataTool : NSObject
/**
 *  返回所有的排序数据（里面都是HMSort模型）
 */
+ (NSArray *)sorts;

/**
 *  返回所有的类别数据（里面都是HMCategory模型）
 */
+ (NSArray *)categories;

/**
 *  返回所有的城市组数据（里面都是HMCityGroup模型）
 */
+ (NSArray *)cityGroups;

/**
 *  返回所有的城市名称（里面都是NSString）
 */
+ (NSArray *)cityNames;

/**
 *  返回所有的城市（里面都是HMCity模型）
 */
+ (NSArray *)cities;

/**
 *  根据城市名字获得城市模型
 *
 *  @param name 城市名字
 *
 *  @return 城市模型
 */
+ (HMCity *)cityWithName:(NSString *)name;
@end
