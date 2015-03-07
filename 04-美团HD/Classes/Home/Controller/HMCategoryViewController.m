//
//  HMCategoryViewController.m
//  04-美团HD
//
//  Created by apple on 15/2/4.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "HMCategoryViewController.h"
#import "HMDataTool.h"
#import "HMCategory.h"
#import "HMDropdownLeftCell.h"
#import "HMDropdownRightCell.h"

@interface HMCategoryViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@end

@implementation HMCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat rowHeight = 40;
    self.leftTableView.rowHeight = rowHeight;
    self.rightTableView.rowHeight = rowHeight;
    self.preferredContentSize = CGSizeMake(400, rowHeight * [HMDataTool categories].count);
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTableView) { // 左边
        return [HMDataTool categories].count;
    } else { // 右边
        // 左边表格选中的行号
        NSInteger leftSelectedRow = [self.leftTableView indexPathForSelectedRow].row;
        HMCategory *category = [HMDataTool categories][leftSelectedRow];
        return category.subcategories.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (tableView == self.leftTableView) { // 左边
        cell = [HMDropdownLeftCell cellWithTableView:tableView];
    
        HMCategory *category = [HMDataTool categories][indexPath.row];
        cell.textLabel.text = category.name;
        cell.accessoryType = category.subcategories.count ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
        cell.imageView.image = [UIImage imageNamed:category.small_icon];
        cell.imageView.highlightedImage = [UIImage imageNamed:category.small_highlighted_icon];
    } else { // 右边
        cell = [HMDropdownRightCell cellWithTableView:tableView];
        
        // 左边表格选中的行号
        NSInteger leftSelectedRow = [self.leftTableView indexPathForSelectedRow].row;
        HMCategory *category = [HMDataTool categories][leftSelectedRow];
        cell.textLabel.text = category.subcategories[indexPath.row];
    }
    return cell;
}

#pragma mark - 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView) { // 左边
        // 刷新右边
        [self.rightTableView reloadData];
        
        // 如果这个类别没有子类别，得发送通知
        HMCategory *category = [HMDataTool categories][indexPath.row];
        if (category.subcategories.count == 0) { // 得发送通知
            [self postNote:category subcategoryIndex:nil];
        }
    } else { // 右边
        // 发送通知
        NSInteger leftSelectedRow = [self.leftTableView indexPathForSelectedRow].row;
        HMCategory *category = [HMDataTool categories][leftSelectedRow];
        [self postNote:category subcategoryIndex:@(indexPath.row)];
    }
}

#pragma mark - 私有方法
- (void)postNote:(HMCategory *)category subcategoryIndex:(id)subcategoryIndex
{
    // 1.销毁当前控制器
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 2.发送通知
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[HMCurrentCategoryKey] = category;
    if (subcategoryIndex) {
        userInfo[HMCurrentSubcategoryIndexKey] = subcategoryIndex;
    }
    [HMNoteCenter postNotificationName:HMCategoryDidChangeNotification object:nil userInfo:userInfo];
}
@end