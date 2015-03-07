//
//  HMLocalDealsViewController.h
//  04-美团HD
//
//  Created by apple on 15/2/9.
//  Copyright (c) 2015年 heima. All rights reserved.
//  本地团购数据（编辑-删除数据功能）

#import "HMBaseDealsViewController.h"

@interface HMLocalDealsViewController : HMBaseDealsViewController
/**
 *  子类实现这个方法来告诉父类怎么删除沙盒中的数据
 */
- (void)deleteLocalDeals:(NSArray *)deletedDeals;

/**
 *  子类实现这个方法来告诉父类：需要显示哪些数据
 */
- (NSArray *)totalDeals;
@end
