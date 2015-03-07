//
//  HMDataTool.m
//  04-美团HD
//
//  Created by apple on 15/2/4.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "HMDataTool.h"
#import <MJExtension.h>
#import "HMSort.h"
#import "HMCategory.h"
#import "HMCityGroup.h"
#import "HMCity.h"

@implementation HMDataTool

static NSArray *_cities;
+ (NSArray *)cities
{
    if (!_cities) {
        _cities = [HMCity objectArrayWithFilename:@"cities.plist"];
    }
    return _cities;
}

static NSArray *_sorts;
+ (NSArray *)sorts
{
    if (!_sorts) {
        _sorts = [HMSort objectArrayWithFilename:@"sorts.plist"];
    }
    return _sorts;
}

static NSArray *_categories;
+ (NSArray *)categories
{
    if (!_categories) {
        _categories = [HMCategory objectArrayWithFilename:@"categories.plist"];
    }
    return _categories;
}

static NSArray *_cityGroups;
+ (NSArray *)cityGroups
{
    if (!_cityGroups) {
        _cityGroups = [HMCityGroup objectArrayWithFilename:@"cityGroups.plist"];
    }
    return _cityGroups;
}

static NSArray *_cityNames;
+ (NSArray *)cityNames
{
    if (!_cityNames) {
        NSMutableArray *cityNames = [NSMutableArray array];
        NSArray *groups = [self cityGroups];
        [groups enumerateObjectsUsingBlock:^(HMCityGroup *group, NSUInteger idx, BOOL *stop) {
            if (idx == 0) return;
            // 将group.cities中的所有元素添加到cityNames中
            [cityNames addObjectsFromArray:group.cities];
        }];
        _cityNames = cityNames;
    }
    return _cityNames;
}

+ (HMCity *)cityWithName:(NSString *)name
{
    if (name.length == 0) return nil;
    
    return [[[self cities] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", name]] firstObject];
}
@end
