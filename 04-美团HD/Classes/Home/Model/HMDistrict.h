//
//  HMDistrict.h
//  04-美团HD
//
//  Created by apple on 15/2/5.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMDistrict : NSObject
/** 区域名称 */
@property (nonatomic, copy) NSString *name;
/** 这个区域的所有子区域 */
@property (nonatomic, strong) NSArray *subdistricts;
@end
