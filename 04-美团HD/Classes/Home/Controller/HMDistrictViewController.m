//
//  HMDistrictViewController.m
//  04-美团HD
//
//  Created by apple on 15/2/4.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "HMDistrictViewController.h"
#import "HMCityViewController.h"
#import "HMNavigationController.h"
#import "HMDropdownLeftCell.h"
#import "HMDropdownRightCell.h"
#import "HMDistrict.h"

@interface HMDistrictViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@end

@implementation HMDistrictViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat rowHeight = 40;
    self.leftTableView.rowHeight = rowHeight;
    self.rightTableView.rowHeight = rowHeight;
    self.preferredContentSize = CGSizeMake(400, 400);
}

#pragma mark - 私有方法
/**
 *  切换城市
 */
- (IBAction)changeCity {
    // 1.销毁当前控制器
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 2.弹出切换城市的控制器
    HMCityViewController *cityVc = [[HMCityViewController alloc] init];
    HMNavigationController *nav = [[HMNavigationController alloc] initWithRootViewController:cityVc];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootVc presentViewController:nav animated:YES completion:nil];
#warning 这里不能使用self来弹出控制器，因为当self销毁了，被self弹出的控制器也会销毁
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTableView) { // 左边
        return self.districts.count;
    } else { // 右边
        // 左边表格选中的行号
        NSInteger leftSelectedRow = [self.leftTableView indexPathForSelectedRow].row;
        HMDistrict *district = self.districts[leftSelectedRow];
        return district.subdistricts.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (tableView == self.leftTableView) { // 左边
        cell = [HMDropdownLeftCell cellWithTableView:tableView];
        
        HMDistrict *district = self.districts[indexPath.row];
        cell.textLabel.text = district.name;
        cell.accessoryType = district.subdistricts.count ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    } else { // 右边
        cell = [HMDropdownRightCell cellWithTableView:tableView];
        
        // 左边表格选中的行号
        NSInteger leftSelectedRow = [self.leftTableView indexPathForSelectedRow].row;
        HMDistrict *district = self.districts[leftSelectedRow];
        cell.textLabel.text = district.subdistricts[indexPath.row];
    }
    return cell;
}

#pragma mark - 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView) { // 左边
        // 刷新右边
        [self.rightTableView reloadData];
        
        // 如果这个区域没有子区域，得发送通知
        HMDistrict *district = self.districts[indexPath.row];
        if (district.subdistricts.count == 0) { // 得发送通知
            [self postNote:district subdistrictIndex:nil];
        }
    } else { // 右边
        // 发送通知
        NSInteger leftSelectedRow = [self.leftTableView indexPathForSelectedRow].row;
        HMDistrict *district = self.districts[leftSelectedRow];
        [self postNote:district subdistrictIndex:@(indexPath.row)];
    }
}

#pragma mark - 私有方法
- (void)postNote:(HMDistrict *)district subdistrictIndex:(id)subdistrictIndex
{
    // 1.销毁当前控制器
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 2.发送通知
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[HMCurrentDistrictKey] = district;
    if (subdistrictIndex) {
        userInfo[HMCurrentSubdistrictIndexKey] = subdistrictIndex;
    }
    [HMNoteCenter postNotificationName:HMDistrictDidChangeNotification object:nil userInfo:userInfo];
}
@end