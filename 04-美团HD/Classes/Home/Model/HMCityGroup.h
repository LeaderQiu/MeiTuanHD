//
//  HMCityGroup.h
//  04-美团HD
//
//  Created by apple on 15/2/5.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMCityGroup : NSObject
/** 这组的名称 */
@property (nonatomic, copy) NSString *title;
/** 这组的城市名称 */
@property (nonatomic, strong) NSArray *cities;
@end
