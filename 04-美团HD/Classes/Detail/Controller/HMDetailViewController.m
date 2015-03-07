//
//  HMDetailViewController.m
//  04-美团HD
//
//  Created by apple on 15/2/7.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "HMDetailViewController.h"
#import "HMDeal.h"
#import <UIView+AutoLayout.h>
#import <UIImageView+WebCache.h>
#import "DPAPI.h"
#import "MBProgressHUD+MJ.h"
#import "HMGetSingleDealResult.h"
#import "HMDealTool.h"
#import <MJExtension.h>

#define HMHtmlFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.html", self.deal.deal_id]]

@interface HMDetailViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, weak) UIActivityIndicatorView *loadingView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *listPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *soldNumberButton;
@property (weak, nonatomic) IBOutlet UIButton *anyTimeRefuntableButton;
@property (weak, nonatomic) IBOutlet UIButton *expiresRefuntableButton;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@end

@implementation HMDetailViewController

- (UIActivityIndicatorView *)loadingView
{
    if (!_loadingView) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.webView addSubview:loadingView];
        
        // 居中
        [loadingView autoCenterInSuperview];
        self.loadingView = loadingView;
    }
    return _loadingView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 处理左边的内容
    [self setupLeftView];
    
    // 处理右边的webView
    [self setupRightView];
    
    // 添加这个团购到访问记录
    [HMDealTool addHistoryDeal:self.deal];
}

/**
 *  处理左边的内容
 */
- (void)setupLeftView
{
    // 收藏按钮
    self.collectButton.selected = [HMDealTool isCollected:self.deal];
    // 图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.deal.image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    // 标题
    self.titleLabel.text = self.deal.title;
    // 描述
    self.descLabel.text = self.deal.desc;
    // 原价
    self.listPriceLabel.text = [NSString stringWithFormat:@"￥%@", self.deal.list_price];
    // 现价
    self.currentPriceLabel.text = [NSString stringWithFormat:@"￥%@", self.deal.current_price];
    // 购买数
    [self.soldNumberButton setTitle:[NSString stringWithFormat:@"已售出%d", self.deal.purchase_count] forState:UIControlStateNormal];
    
    // 获得过期时间
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSDate *dead = [fmt dateFromString:self.deal.purchase_deadline];
    // 增加一天的过期时间
    dead = [dead dateByAddingTimeInterval:24 * 60 * 60];

    // 比较过期时间和当前时间
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *cmps = [calendar components:unit fromDate:[NSDate date] toDate:dead options:kNilOptions];
    
    // 设置剩余时间
    if (cmps.day >= 30) {
        [self.leftTimeButton setTitle:@"未来1个月内有效" forState:UIControlStateNormal];
    } else {
        [self.leftTimeButton setTitle:[NSString stringWithFormat:@"剩余%d天%d小时%d分", cmps.day, cmps.hour, cmps.minute] forState:UIControlStateNormal];
    }
    
    // 发送请求给服务器获得更详细的团购信息
    NSDictionary *params = @{@"deal_id" : self.deal.deal_id};
    [[DPAPI sharedInstance] request:@"v1/deal/get_single_deal" params:params success:^(id json) {
        HMGetSingleDealResult *result = [HMGetSingleDealResult objectWithKeyValues:json];
        self.deal = [result.deals lastObject];
        
        self.anyTimeRefuntableButton.selected = self.deal.is_refundable;
        self.expiresRefuntableButton.selected = self.deal.is_refundable;
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"找不到指定的团购信息"];
    }];
}

/**
 *  处理右边的webView
 */
- (void)setupRightView
{
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    // 开始转圈圈
    [self.loadingView startAnimating];
    // 隐藏
    self.webView.scrollView.hidden = YES;
    // 加载右边的页面
//    if ([[NSFileManager defaultManager] fileExistsAtPath:HMHtmlFile]) {
//        // 先尝试加载本地的HTML文件
//        NSString *html = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:HMHtmlFile] encoding:NSUTF8StringEncoding error:nil];
//        [self.webView loadHTMLString:html baseURL:nil];
//        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:HMHtmlFile]]];
//    } else {
//        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.deal.deal_h5_url]]];
//    }
}

#pragma mark - 监听按钮点击
- (IBAction)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)collect:(UIButton *)btn {
    if (btn.isSelected) { // 已经被收藏，现在需要取消收藏
        [HMDealTool uncollect:self.deal];
    } else { // 没有被收藏，现在需要收藏
        [HMDealTool collect:self.deal];
    }
    
    btn.selected = !btn.isSelected;
}

/**
 *  设置当前控制器支持哪些方向
 *
 *  @return 这里返回的常量都是带有Mask单词（没有Mask单词的常量是用来判断控制器方向的 -- UIInterfaceOrientation）
 */
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}

#pragma mark - <UIWebViewDelegate>
/**
 *  webView加载完毕时候调用
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 刚才请求的地址
    NSString *lastUrl = webView.request.URL.absoluteString;
//    if ([lastUrl hasPrefix:@"file"])  return;
    
    // 截取id
    NSString *ID = [self.deal.deal_id substringFromIndex:2];
    if ([lastUrl hasSuffix:ID]) { // 加载详情完毕
        // 执行JS删掉不需要的节点
        NSString *js = @"document.getElementsByTagName('header')[0].remove();"
                        "document.getElementsByClassName('cost-box')[0].remove();"
                        "document.getElementsByClassName('buy-now')[0].remove();";
        [webView stringByEvaluatingJavaScriptFromString:js];
        
        // 停止动画
        [self.loadingView stopAnimating];
        
        // 显示webView
        webView.scrollView.hidden = NO;
        
        // 将HTML源码保存到沙盒中
//        NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('html')[0].outerHTML;"];
//        [html writeToFile:HMHtmlFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    } else { // 加载详情
        NSString *url = [NSString stringWithFormat:@"http://lite.m.dianping.com/group/deal/moreinfo/%@", ID];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
}
@end
