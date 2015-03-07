//
//  HMBaseDealsViewController.h
//  04-美团HD
//
//  Created by apple on 15/2/9.
//  Copyright (c) 2015年 heima. All rights reserved.
//  所有团购列表控制器的基类（展示cell，设置布局）

#import <UIKit/UIKit.h>

@interface HMBaseDealsViewController : UICollectionViewController
/** 显示的所有团购 */
@property (nonatomic, strong) NSMutableArray *deals;
/**
 *  子类实现这个方法来告诉父类没有数据的图片名
 */
- (NSString *)noDataImageName;
@end
