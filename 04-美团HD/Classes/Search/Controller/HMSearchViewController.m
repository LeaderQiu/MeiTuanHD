//
//  HMSearchViewController.m
//  04-美团HD
//
//  Created by apple on 15/2/4.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "HMSearchViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "HMHomeTopItem.h"
#import "HMSortViewController.h"
#import "HMCategoryViewController.h"
#import "HMDistrictViewController.h"
#import "HMSort.h"
#import "HMCategory.h"
#import "HMCity.h"
#import "HMDistrict.h"
#import "DPAPI.h"
#import "HMFindDealsResult.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "HMDealCell.h"
#import "MBProgressHUD+MJ.h"
#import <UIView+AutoLayout.h>
#import "HMDetailViewController.h"
#import "HMDataTool.h"
#import "AwesomeMenu.h"
#import "HMCollectViewController.h"
#import "HMNavigationController.h"
#import "HMHistoryViewController.h"

@interface HMSearchViewController () <UISearchBarDelegate>
@property (nonatomic, weak) UISearchBar *searchBar;

/** 记录一些当前数据 */
/** 返回结果 */
@property (nonatomic, strong) HMFindDealsResult *result;
/** 当前页面 */
@property (nonatomic, assign) int currentPage;
/** 当前正在发送的网络请求 */
@property (nonatomic, weak) DPRequest *currentRequest;
@end

@implementation HMSearchViewController

- (NSString *)noDataImageName
{
    return @"icon_deals_empty";
}

#pragma mark - 初始化方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏
    [self setupNav];
    
    // 增加刷新功能
    [self setupRefresh];
}

/**
 *  增加刷新功能
 */
- (void)setupRefresh
{
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoreDeals)];
    self.collectionView.footerHidden = YES;
}

- (void)dealloc
{
    // 清除正在发送的请求
    [self.currentRequest disconnect];
}

/**
 *  设置导航栏
 */
- (void)setupNav
{
    // 1.返回
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"icon_back" highImage:@"icon_back_highlighted" target:self action:@selector(back)];
    
    // 2.搜索框
    
    UIView *titleView = [[UIView alloc] init];
    titleView.width = 250;
    titleView.height = 35;
    self.navigationItem.titleView = titleView;
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.frame = titleView.bounds;
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
    searchBar.delegate = self;
    [titleView addSubview:searchBar];
    self.searchBar = searchBar;
}

#pragma mark - <searchBarDelegate>
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // 添加遮盖
    [MBProgressHUD showMessage:@"哥正在帮你搜索团购..."];
    
    self.currentPage = 0;
    [self loadMoreDeals];
}

#pragma mark - 导航栏事件处理
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 私有方法
- (void)loadMoreDeals
{
    // 取消上一个请求
    [self.currentRequest disconnect];
    
    int tempPage = self.currentPage;
    tempPage++;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 城市
    params[@"city"] = self.cityName;
    // 页码
    params[@"page"] = @(tempPage);
    // 搜索条件
    params[@"keyword"] = self.searchBar.text;
    
    // 发送请求给服务器
    self.currentRequest = [[DPAPI sharedInstance] request:@"v1/deal/find_deals" params:params success:^(id json) {
        self.result = [HMFindDealsResult objectWithKeyValues:json];
        
        // 如果是第一页的数据。清除掉以前的数据
        if (tempPage == 1) {
            [self.deals removeAllObjects];
        }
        // 添加新数据
        [self.deals addObjectsFromArray:self.result.deals];
        
        // 刷新表格
        [self.collectionView reloadData];
        
        // 结束刷新
        [self.collectionView footerEndRefreshing];
        [MBProgressHUD hideHUD];
        
        // 修改页面
        self.currentPage = tempPage;
        
        if (tempPage == 1 && self.deals.count) {
            // 让表格滚动到最前面
            [self.collectionView setContentOffset:CGPointZero animated:YES];
        }
    } failure:^(NSError *error) {
        // 失败信息
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络繁忙，请稍后再试"];
        
        // 结束刷新
        [self.collectionView footerEndRefreshing];
    }];
}

#pragma mark - 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = [super collectionView:collectionView numberOfItemsInSection:section];
    self.collectionView.footerHidden = (count == self.result.total_count);
    return count;
}
@end
