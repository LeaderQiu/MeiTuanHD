//
//  HMCityViewController.m
//  04-美团HD
//
//  Created by apple on 15/2/5.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "HMCityViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "HMDataTool.h"
#import "HMCityGroup.h"
#import "HMCityResultViewController.h"
#import <UIView+AutoLayout.h>

@interface HMCityViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 遮盖 */
@property (nonatomic, weak) IBOutlet UIButton *cover;
/** 城市搜索结果 */
@property (nonatomic, weak) HMCityResultViewController *cityResultVc;
@end

@implementation HMCityViewController

#pragma mark - 懒加载
- (HMCityResultViewController *)cityResultVc
{
    if (!_cityResultVc) {
        HMCityResultViewController *cityResultVc = [[HMCityResultViewController alloc] init];
        [self addChildViewController:cityResultVc];
        [self.view addSubview:cityResultVc.view];
        
        [cityResultVc.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [cityResultVc.view autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.tableView];
        
        self.cityResultVc = cityResultVc;
    }
    return _cityResultVc;
}

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"切换城市";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"btn_navigation_close" highImage:@"btn_navigation_close_hl" target:self action:@selector(close)];
    
    // 设置表格的索引文字颜色
    self.tableView.sectionIndexColor = [UIColor blackColor];
    
    // 监听按钮
    [self.cover addTarget:self.searchBar action:@selector(resignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <UISearchBarDelegate>
/**
 *  当搜索框已经进入编辑状态（键盘已经弹出）
 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // 1.让搜索框背景变为绿色
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield_hl"];
    // 2.出现cancel按钮
    [searchBar setShowsCancelButton:YES animated:YES];
    // 3.导航条消失（通过动画向上消失）
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    // 4.添加蒙版
    self.cover.hidden = NO;
}

/**
 *  当搜索框已经退出编辑状态（键盘已经退下）
 */
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    // 1.让搜索框背景变为灰色
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
    // 2.隐藏cancel按钮
    [searchBar setShowsCancelButton:NO animated:YES];
    // 3.导航条出现（通过动画向下出现）
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    // 4.移除蒙版
    self.cover.hidden = YES;
    // 5.清空搜索框文字
    searchBar.text = nil;
    // 6.隐藏搜索结果控制器
    self.cityResultVc.view.hidden = YES;
}

/**
 *  点击取消按钮
 */
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:YES];
}

/**
 *  搜索框的文字改变
 *
 *  @param searchText 搜索框当前的文字（搜索条件）
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.cityResultVc.view.hidden = (searchText.length == 0);
    self.cityResultVc.searchText = searchText;
}

#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [HMDataTool cityGroups].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HMCityGroup *cityGroup = [HMDataTool cityGroups][section];
    return cityGroup.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"city";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    // 设置城市名称
    HMCityGroup *cityGroup = [HMDataTool cityGroups][indexPath.section];
    cell.textLabel.text = cityGroup.cities[indexPath.row];
    
    return cell;
}

#pragma mark - 代理方法
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    HMCityGroup *cityGroup = [HMDataTool cityGroups][section];
    return cityGroup.title;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
//    NSMutableArray *titles = [NSMutableArray array];
//    [[HMDataTool cityGroups] enumerateObjectsUsingBlock:
//     ^(HMCityGroup *group, NSUInteger idx, BOOL *stop) {
//         [titles addObject:group.title];
//    }];
//    return titles;
    
//    NSArray *groups = [HMDataTool cityGroups];
//    HMCityGroup *group = [groups lastObject];
//    HMLog(@"%@", [group valueForKeyPath:@"title"]); // 相当于group.title
    // 将groups数组中所有元素的title属性取出来，放到一个新的数组中
//    HMLog(@"%@", [groups valueForKeyPath:@"title"]);
    return [[HMDataTool cityGroups] valueForKeyPath:@"title"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 销毁
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 取出城市名字
    HMCityGroup *cityGroup = [HMDataTool cityGroups][indexPath.section];
    NSString *cityName = cityGroup.cities[indexPath.row];
    
    // 根据城市名字 获得 城市模型
    HMCity *city = [HMDataTool cityWithName:cityName];
    
    // 发出通知
    NSDictionary *userInfo = @{HMCurrentCityKey : city};
    [HMNoteCenter postNotificationName:HMCityDidChangeNotification object:nil userInfo:userInfo];
}
@end
