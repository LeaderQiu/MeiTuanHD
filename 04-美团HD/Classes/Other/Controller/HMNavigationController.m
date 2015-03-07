//
//  HMNavigationController.m
//  04-美团HD
//
//  Created by apple on 15/2/4.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "HMNavigationController.h"

@interface HMNavigationController ()

@end

@implementation HMNavigationController

+ (void)initialize
{
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"bg_navigationBar_normal"] forBarMetrics:UIBarMetricsDefault];
    
    // 设置导航栏上面item的文字属性
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    // 普通文字颜色
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = HMColor(21, 188, 173); // 文字颜色
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    // 不可交互时的文字颜色
    NSMutableDictionary *disabledAttrs = [NSMutableDictionary dictionary];
    disabledAttrs[NSForegroundColorAttributeName] = HMARGBColor(100, 100, 100, 0.5); // 文字颜色
    [item setTitleTextAttributes:disabledAttrs forState:UIControlStateDisabled];
}

// 文字大小
//    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:25];
//    UITextAttributeTextColor(iOS7之前) --> NSForegroundColorAttributeName（iOS7开始）
//    UITextAttributeFont(iOS7之前) --> NSFontAttributeName（iOS7开始）
// 背景色
//    attrs[NSBackgroundColorAttributeName] = ;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
