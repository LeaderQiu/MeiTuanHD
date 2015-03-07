//
//  _4___HDTests.m
//  04-美团HDTests
//
//  Created by apple on 15/2/2.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NSString+Extension.h"

@interface _4___HDTests : XCTestCase

@end

@implementation _4___HDTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testString
{
    NSString *str = @"89.900003424";
    
    NSString *result = [str dealedPriceString];

    NSAssert([result isEqualToString:@"89.9"], @"dealedPriceString处理有问题");
}

// 单元测试：测试某个单元（某个业务功能）
// 红灯：测试不通过
// 绿灯：测试通过
- (void)testCanlendar
{
    // 创建日历对象（能完成很多的日期处理）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 创建日期
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date1 = [fmt dateFromString:@"2013-08-06 22:35:20"];
    NSDate *date2 = [fmt dateFromString:@"2015-08-06 22:35:20"];
    
    // 比较时间
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *cmps = [calendar components:unit fromDate:date1 toDate:date2 options:kNilOptions];
    
    
    NSAssert(cmps.year == 2, @"NSCalendar计算有问题");
    
//    NSLog(@"--------------华丽的分割线--------------");
//    NSLog(@"相差 %d年 %d月 %d天 %d小时 %d分钟 %d秒", cmps.year, cmps.month, cmps.day, cmps.hour, cmps.minute, cmps.second);
//    NSLog(@"--------------忧伤的分割线--------------");
    
    // 获得date的某个元素（年月日时分秒等元素）
//    NSDate *date = [NSDate date];
//    NSInteger year = [calendar component:NSCalendarUnitDay fromDate:date];
//    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
//    NSLog(@"%d %d %d", cmps.year, cmps.month, cmps.day);
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
