//
//  HMCategory.h
//  04-美团HD
//
//  Created by apple on 15/2/4.
//  Copyright (c) 2015年 heima. All rights reserved.
//  类别模型（比如美食、旅游）

#import <Foundation/Foundation.h>

@interface HMCategory : NSObject
/** 类别名称（比如美食、旅游） */
@property (nonatomic, copy) NSString *name;
/** 子类别（比如粤菜、鲁菜、赣菜） */
@property (nonatomic, strong) NSArray *subcategories;

/** 显示在下拉菜单的小图标 */
@property (nonatomic, copy) NSString *small_highlighted_icon;
@property (nonatomic, copy) NSString *small_icon;

/** 显示在导航栏顶部的大图标 */
@property (nonatomic, copy) NSString *highlighted_icon;
@property (nonatomic, copy) NSString *icon;
@end
