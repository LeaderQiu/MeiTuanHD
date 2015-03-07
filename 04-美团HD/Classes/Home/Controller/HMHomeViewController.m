//
//  HMHomeViewController.m
//  04-美团HD
//
//  Created by apple on 15/2/4.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "HMHomeViewController.h"
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
#import "HMSearchViewController.h"

// 环信 - 即时通讯

@interface HMHomeViewController () <AwesomeMenuDelegate>
/** 类别item */
@property (nonatomic, strong) UIBarButtonItem *categoryItem;
/** 区域item */
@property (nonatomic, strong) UIBarButtonItem *districtItem;
/** 排序item */
@property (nonatomic, strong) UIBarButtonItem *sortItem;

/** 记录一些当前数据 */
/** 返回结果 */
@property (nonatomic, strong) HMFindDealsResult *result;
/** 当前页面 */
@property (nonatomic, assign) int currentPage;
/** 当前的城市 */
@property (nonatomic, strong) HMCity *currentCity;
/** 当前的排序 */
@property (nonatomic, strong) HMSort *currentSort;
/** 当前的类别名称(发给服务器) */
@property (nonatomic, copy) NSString *currentCategoryName;
/** 当前的区域名称(发给服务器) */
@property (nonatomic, copy) NSString *currentRegionName;
/** 当前正在发送的网络请求 */
@property (nonatomic, weak) DPRequest *currentRequest;
@end

@implementation HMHomeViewController

- (NSString *)noDataImageName
{
    return @"icon_deals_empty";
}

#pragma mark - 初始化方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏左边
    [self setupNavLeft];
    
    // 设置导航栏右边
    [self setupNavRight];
    
    // 监听通知
    [self setupNotes];
    
    // 增加刷新功能
    [self setupRefresh];
    
    // 增加环形菜单
    [self setupAwesomeMenu];
}

/**
 *  增加环形菜单
 */
- (void)setupAwesomeMenu
{
    // 所有item的公共背景
    UIImage *itemBg = [UIImage imageNamed:@"bg_pathMenu_black_normal"];
    
    // 创建菜单item（按钮）
    // 1.个人信息
    AwesomeMenuItem *personalItem = [[AwesomeMenuItem alloc] initWithImage:itemBg highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_mine_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_mine_highlighted"]];
    
    // 2.收藏
    AwesomeMenuItem *collectItem = [[AwesomeMenuItem alloc] initWithImage:itemBg highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_highlighted"]];
    
    // 3.历史记录
    AwesomeMenuItem *historyItem = [[AwesomeMenuItem alloc] initWithImage:itemBg highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_scan_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_scan_highlighted"]];
    
    // 4.更多
    AwesomeMenuItem *moreItem = [[AwesomeMenuItem alloc] initWithImage:itemBg highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_more_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_more_highlighted"]];
    
    // 5.开始
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_pathMenu_background_normal"] highlightedImage:[UIImage imageNamed:@"icon_pathMenu_background_highlighted"] ContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_highlighted"]];

    // 创建菜单
    NSArray *items = @[personalItem, collectItem, historyItem, moreItem];
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:CGRectZero startItem:startItem optionMenus:items];
    menu.delegate = self;
    menu.alpha = 0.5;
    [self.view addSubview:menu];
    
    // 设置菜单约束
    [menu autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [menu autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    CGFloat menuWH = 250;
    [menu autoSetDimensionsToSize:CGSizeMake(menuWH, menuWH)];
    
    // 设置菜单信息
    CGFloat margin = 50;
    menu.menuWholeAngle = M_PI_2;
    menu.startPoint = CGPointMake(margin, menuWH - margin);
    menu.rotateAddButton = NO;
}

/**
 *  增加刷新功能
 */
- (void)setupRefresh
{
    [self.collectionView addHeaderWithTarget:self action:@selector(loadNewDeals)];
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoreDeals)];
    self.collectionView.footerHidden = YES;
    
    
#warning TODO
    self.currentCity = [HMDataTool cityWithName:@"北京"];
    [self.collectionView headerBeginRefreshing];
}

/**
 *  监听通知
 */
- (void)setupNotes
{
    [HMNoteCenter addObserver:self selector:@selector(sortDidChange:) name:HMSortDidChangeNotification object:nil];
    [HMNoteCenter addObserver:self selector:@selector(categoryDidChange:) name:HMCategoryDidChangeNotification object:nil];
    [HMNoteCenter addObserver:self selector:@selector(cityDidChange:) name:HMCityDidChangeNotification object:nil];
    [HMNoteCenter addObserver:self selector:@selector(districtDidChange:) name:HMDistrictDidChangeNotification object:nil];
}

- (void)dealloc
{
    [HMNoteCenter removeObserver:self];
    
    // 清除正在发送的请求
    [self.currentRequest disconnect];
}

/**
 *  设置导航栏左边
 */
- (void)setupNavLeft
{
    // logo
    UIBarButtonItem *logoItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_meituan_logo"] style:UIBarButtonItemStylePlain target:nil action:nil];
    logoItem.enabled = NO;
    
    // 类别
    HMHomeTopItem *categoryTopItem = [HMHomeTopItem item];
    [categoryTopItem setIcon:@"icon_category_-1" highIcon:@"icon_category_highlighted_-1"];
    categoryTopItem.title = @"全部分类";
    categoryTopItem.subtitle = nil;
    [categoryTopItem addTarget:self action:@selector(categoryClick)];
    self.categoryItem = [[UIBarButtonItem alloc] initWithCustomView:categoryTopItem];
    
    // 区域
    HMHomeTopItem *districtTopItem = [HMHomeTopItem item];
    [districtTopItem setIcon:@"icon_district" highIcon:@"icon_district_highlighted"];
    districtTopItem.title = @"北京 - 全部";
    districtTopItem.subtitle = nil;
    [districtTopItem addTarget:self action:@selector(districtClick)];
    self.districtItem = [[UIBarButtonItem alloc] initWithCustomView:districtTopItem];
    
    // 排序
    HMHomeTopItem *sortTopItem = [HMHomeTopItem item];
    [sortTopItem setIcon:@"icon_sort" highIcon:@"icon_sort_highlighted"];
    sortTopItem.title = @"排序";
    sortTopItem.subtitle = @"默认排序";
    [sortTopItem addTarget:self action:@selector(sortClick)];
    self.sortItem = [[UIBarButtonItem alloc] initWithCustomView:sortTopItem];
    
    self.navigationItem.leftBarButtonItems = @[logoItem, self.categoryItem, self.districtItem, self.sortItem];
}

/**
 *  设置导航栏右边
 */
- (void)setupNavRight
{
    // search
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithImage:@"icon_search" highImage:@"icon_search_highlighted" target:self action:@selector(searchClick)];
    searchItem.customView.width = 50;
    
    // map
    UIBarButtonItem *mapItem = [UIBarButtonItem itemWithImage:@"icon_map" highImage:@"icon_map_highlighted" target:self action:@selector(mapClick)];
    mapItem.customView.width = searchItem.customView.width;
    
    self.navigationItem.rightBarButtonItems = @[mapItem, searchItem];
}

#pragma mark - <AwesomeMenuDelegate>
- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    switch (idx) {
        case 0: // 个人
            break;
        case 1: { // 收藏
            HMCollectViewController *collectVc = [[HMCollectViewController alloc] init];
            HMNavigationController *nav = [[HMNavigationController alloc] initWithRootViewController:collectVc];
            [self presentViewController:nav animated:YES completion:nil];
            break;
        }
        case 2: { // 历史
            HMHistoryViewController *historyVc = [[HMHistoryViewController alloc] init];
            HMNavigationController *nav = [[HMNavigationController alloc] initWithRootViewController:historyVc];
            [self presentViewController:nav animated:YES completion:nil];
            break;
        }
        case 3: // 更多
            break;
    }
    
    [self awesomeMenuWillAnimateClose:menu];
}

- (void)awesomeMenuWillAnimateOpen:(AwesomeMenu *)menu
{
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_cross_normal"];
    menu.highlightedContentImage = [UIImage imageNamed:@"icon_pathMenu_cross_highlighted"];
    menu.alpha = 1.0;
}

- (void)awesomeMenuDidFinishAnimationOpen:(AwesomeMenu *)menu
{

}

- (void)awesomeMenuWillAnimateClose:(AwesomeMenu *)menu
{
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_normal"];
    menu.highlightedContentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_highlighted"];
    menu.alpha = 0.5;
}

- (void)awesomeMenuDidFinishAnimationClose:(AwesomeMenu *)menu
{
    
}

#pragma mark - 通知处理
- (void)sortDidChange:(NSNotification *)note
{
    // 更新导航栏顶部
    HMHomeTopItem *topItem = (HMHomeTopItem *)self.sortItem.customView;
    self.currentSort = note.userInfo[HMCurrentSortKey];
    topItem.subtitle = self.currentSort.label;
    
    // 重新发送请求给服务器
    [self.collectionView headerBeginRefreshing];
}

- (void)categoryDidChange:(NSNotification *)note
{
    // 更新导航栏顶部
    HMHomeTopItem *topItem = (HMHomeTopItem *)self.categoryItem.customView;
    
    // 取出模型
    HMCategory *category = note.userInfo[HMCurrentCategoryKey];
    int subcategoryIndex = [note.userInfo[HMCurrentSubcategoryIndexKey] intValue];
    NSString *subcategory = category.subcategories[subcategoryIndex];
    
    // 设置数据
    topItem.title = category.name;
    topItem.subtitle = subcategory;
    [topItem setIcon:category.icon highIcon:category.highlighted_icon];
    
    // 记录发送给服务器的类别名称
    self.currentCategoryName = subcategory ? subcategory : category.name;
    if ([self.currentCategoryName isEqualToString:@"全部"]) { // 点击了子类别中的全部
        self.currentCategoryName = category.name;
    } else if ([self.currentCategoryName isEqualToString:@"全部分类"]) {
        self.currentCategoryName = nil;
    }
    
    // 重新发送请求给服务器
    [self.collectionView headerBeginRefreshing];
}

- (void)cityDidChange:(NSNotification *)note
{
    // 更新导航栏顶部
    HMHomeTopItem *topItem = (HMHomeTopItem *)self.districtItem.customView;
    // 取出模型
    self.currentCity = note.userInfo[HMCurrentCityKey];
    self.currentRegionName = nil;
    topItem.title = [NSString stringWithFormat:@"%@ - 全部", self.currentCity.name];
    topItem.subtitle = nil;
    
    // 重新发送请求给服务器
    [self.collectionView headerBeginRefreshing];
}

- (void)districtDidChange:(NSNotification *)note
{
    // 更新导航栏顶部
    HMHomeTopItem *topItem = (HMHomeTopItem *)self.districtItem.customView;
    // 取出模型
    HMDistrict *district = note.userInfo[HMCurrentDistrictKey];
    int subdistrictIndex = [note.userInfo[HMCurrentSubdistrictIndexKey] intValue];
    NSString *subdistrict = district.subdistricts[subdistrictIndex];
    
    // 设置数据
    topItem.title = [NSString stringWithFormat:@"%@ - %@", self.currentCity.name, district.name];
    topItem.subtitle = subdistrict;
    
    // 记录发给服务器的区域名称
    self.currentRegionName = subdistrict ? subdistrict : district.name;
    if ([self.currentRegionName isEqualToString:@"全部"]) {
        self.currentRegionName = subdistrict ? district.name : nil;
    }
    
    // 重新发送请求给服务器
    [self.collectionView headerBeginRefreshing];
}

#pragma mark - 导航栏事件处理
/**
 *  点击了类别
 */
- (void)categoryClick
{
    HMCategoryViewController *categoryVc = [[HMCategoryViewController alloc] init];
    categoryVc.modalPresentationStyle = UIModalPresentationPopover;
    categoryVc.popoverPresentationController.barButtonItem = self.categoryItem;
    [self presentViewController:categoryVc animated:YES completion:nil];
}

/**
 *  点击了区域
 */
- (void)districtClick
{
    HMDistrictViewController *districtVc = [[HMDistrictViewController alloc] init];
    districtVc.modalPresentationStyle = UIModalPresentationPopover;
    districtVc.popoverPresentationController.barButtonItem = self.districtItem;
    districtVc.districts = self.currentCity.districts;
    [self presentViewController:districtVc animated:YES completion:nil];
}

/**
 *  点击了排序
 */
- (void)sortClick
{
    HMSortViewController *sortVc = [[HMSortViewController alloc] init];
    sortVc.modalPresentationStyle = UIModalPresentationPopover;
    sortVc.popoverPresentationController.barButtonItem = self.sortItem;
    [self presentViewController:sortVc animated:YES completion:nil];
}

/**
 *  点击了搜索
 */
- (void)searchClick
{
    if (self.currentCity == nil) {
        [MBProgressHUD showError:@"请选择城市后再搜索"];
        return;
    }
    
    HMSearchViewController *searchVc = [[HMSearchViewController alloc] init];
    searchVc.cityName = self.currentCity.name;
    HMNavigationController *nav = [[HMNavigationController alloc] initWithRootViewController:searchVc];
    [self presentViewController:nav animated:YES completion:nil];
}

/**
 *  点击了地图
 */
- (void)mapClick
{
    HMLog(@"mapClick");
}

#pragma mark - 私有方法
- (void)loadNewDeals
{
    if (self.currentCity == nil) return;
    
    // 取消上一个请求
    [self.currentRequest disconnect];
    [self.collectionView footerEndRefreshing];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 城市
    params[@"city"] = self.currentCity.name;
    // 区域
    if (self.currentRegionName) params[@"region"] = self.currentRegionName;
    // 类别
    if (self.currentCategoryName) params[@"category"] = self.currentCategoryName;
    // 排序
    if (self.currentSort) params[@"sort"] = @(self.currentSort.value);
    
    // 发送请求给服务器
    self.currentRequest = [[DPAPI sharedInstance] request:@"v1/deal/find_deals" params:params success:^(id json) {
        self.result = [HMFindDealsResult objectWithKeyValues:json];
        
        // 移除旧数据
        [self.deals removeAllObjects];
        
        // 添加新数据
        [self.deals addObjectsFromArray:self.result.deals];
        
        // 刷新表格
        [self.collectionView reloadData];
        
        // 结束刷新
        [self.collectionView headerEndRefreshing];
        
        // 修改页面
        self.currentPage = 1;
    } failure:^(NSError *error) {
        // 失败信息
        [MBProgressHUD showError:@"网络繁忙，请稍后再试"];
        
        // 结束刷新
        [self.collectionView headerEndRefreshing];
    }];
}

- (void)loadMoreDeals
{
    if (self.currentCity == nil) return;
    
    // 取消上一个请求
    [self.currentRequest disconnect];
    [self.collectionView headerEndRefreshing];
    
    int tempPage = self.currentPage;
    tempPage++;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 城市
    params[@"city"] = self.currentCity.name;
    // 区域
    if (self.currentRegionName) params[@"region"] = self.currentRegionName;
    // 类别
    if (self.currentCategoryName) params[@"category"] = self.currentCategoryName;
    // 排序
    if (self.currentSort) params[@"sort"] = @(self.currentSort.value);
    // 页码
    params[@"page"] = @(tempPage);
    
    // 发送请求给服务器
    self.currentRequest = [[DPAPI sharedInstance] request:@"v1/deal/find_deals" params:params success:^(id json) {
        self.result = [HMFindDealsResult objectWithKeyValues:json];
        
        // 添加新数据
        [self.deals addObjectsFromArray:self.result.deals];
        
        // 刷新表格
        [self.collectionView reloadData];
        
        // 结束刷新
        [self.collectionView footerEndRefreshing];
        
        // 修改页面
        self.currentPage = tempPage;
    } failure:^(NSError *error) {
        // 失败信息
        [MBProgressHUD showError:@"网络繁忙，请稍后再试"];
        
        // 结束刷新
        [self.collectionView footerEndRefreshing];
    }];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = [super collectionView:collectionView numberOfItemsInSection:section];
    self.collectionView.footerHidden = (count == self.result.total_count);
    return count;
}
@end
