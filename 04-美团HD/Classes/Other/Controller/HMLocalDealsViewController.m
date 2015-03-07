//
//  HMLocalDealsViewController.m
//  04-美团HD
//
//  Created by apple on 15/2/8.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "HMLocalDealsViewController.h"
#import "HMDealTool.h"
#import "HMDeal.h"
#import <UIView+AutoLayout.h>
#import "UIBarButtonItem+Extension.h"

static NSString *const HMEdit = @"编辑";
static NSString *const HMDone = @"完成";

// 在参数前面加个#，代表给参数包裹一个双引号（比如#text --> "text"）
//#define HMNavLeftText(text) [NSString stringWithFormat:@"   %@  ", @#text]
#define HMNavLeftText(text) [NSString stringWithFormat:@"   %@  ", text]

@interface HMLocalDealsViewController ()
/** 左边的所有item */
@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic, strong) UIBarButtonItem *selectAllItem;
@property (nonatomic, strong) UIBarButtonItem *unselectAllItem;
@property (nonatomic, strong) UIBarButtonItem *deleteItem;
@end

@implementation HMLocalDealsViewController

#pragma mark - 懒加载
- (UIBarButtonItem *)backItem
{
    if (!_backItem) {
        _backItem = [UIBarButtonItem itemWithImage:@"icon_back" highImage:@"icon_back_highlighted" target:self action:@selector(back)];
    }
    return _backItem;
}
- (UIBarButtonItem *)selectAllItem
{
    if (!_selectAllItem) {
        _selectAllItem = [[UIBarButtonItem alloc] initWithTitle:HMNavLeftText(@"全选")  style:UIBarButtonItemStyleDone target:self action:@selector(selectAll)];
    }
    return _selectAllItem;
}
- (UIBarButtonItem *)unselectAllItem
{
    if (!_unselectAllItem) {
        _unselectAllItem = [[UIBarButtonItem alloc] initWithTitle:HMNavLeftText(@"全不选") style:UIBarButtonItemStyleDone target:self action:@selector(unselectAll)];
    }
    return _unselectAllItem;
}
- (UIBarButtonItem *)deleteItem
{
    if (!_deleteItem) {
        _deleteItem = [[UIBarButtonItem alloc] initWithTitle:HMNavLeftText(@"删除") style:UIBarButtonItemStyleDone target:self action:@selector(delete)];
        _deleteItem.enabled = NO;
    }
    return _deleteItem;
}

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏内容
    [self setupNav];
    
    // 监听通知
    [HMNoteCenter addObserver:self selector:@selector(coverClick) name:HMCellCoverDidClickNotification object:nil];
}

- (void)dealloc
{
    [HMNoteCenter removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 清空之前的数据
    [self.deals removeAllObjects];
    
    // 添加新的数据
    [self.deals addObjectsFromArray:[self totalDeals]];
    
    // 清空模型的状态
    for (HMDeal *deal in self.deals) {
        deal.editing = NO;
        deal.checked = NO;
    }
    
    // 控制右上角编辑能否交互
    self.navigationItem.rightBarButtonItem.enabled = (self.deals.count > 0);
    
    // 刷新表格
    [self.collectionView reloadData];
}

/**
 *  设置导航栏内容
 */
- (void)setupNav
{
    self.navigationItem.leftBarButtonItem = self.backItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:HMEdit style:UIBarButtonItemStyleDone target:self action:@selector(edit)];
}

#pragma mark - 监听通知
- (void)coverClick
{
    NSUInteger count = [self.deals filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"checked == YES"]].count;
    if (count) {
        NSString *title = [NSString stringWithFormat:@"删除(%zd)", count];
        self.deleteItem.title = HMNavLeftText(title);
        self.deleteItem.enabled = YES;
    } else {
        self.deleteItem.title = HMNavLeftText(@"删除");
        self.deleteItem.enabled = NO;
    }
}

#pragma mark - 监听点击
- (void)edit
{
    NSString *title = self.navigationItem.rightBarButtonItem.title;
    if ([title isEqualToString:HMEdit]) { // 进入编辑模式
        self.navigationItem.rightBarButtonItem.title = HMDone;
        
        // 控制左边的（全选 全不选 删除）出现
        self.navigationItem.leftBarButtonItems = @[self.backItem, self.selectAllItem, self.unselectAllItem, self.deleteItem];
        
        // 让所有cell的蒙版出现
        for (HMDeal *deal in self.deals) {
            deal.editing = YES;
        }
        [self.collectionView reloadData];
    } else { // 结束编辑模式
        self.navigationItem.rightBarButtonItem.title = HMEdit;
        
        // 控制左边的（全选 全不选 删除）消失
        self.navigationItem.leftBarButtonItems = @[self.backItem];
        
        // 让所有cell的蒙版消失
        for (HMDeal *deal in self.deals) {
            deal.editing = NO;
            deal.checked = NO;
        }
        [self.collectionView reloadData];
    }
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectAll
{
    for (HMDeal *deal in self.deals) {
        deal.checked = YES;
    }
    [self.collectionView reloadData];
    
    [self coverClick];
}

- (void)unselectAll
{
    for (HMDeal *deal in self.deals) {
        deal.checked = NO;
    }
    [self.collectionView reloadData];
    
    [self coverClick];
}

- (void)delete
{
    // 取出将要删除的团购数据
    NSArray *deletedDeals = [self.deals filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"checked == YES"]];
    
    // 删除沙盒中的数据
    [self deleteLocalDeals:deletedDeals];
    
    // 刷新数据
    [self.deals removeObjectsInArray:deletedDeals];
    [self.collectionView reloadData];
    
    // 刷新删除按钮
    [self coverClick];
}
@end
