//
//  HMDealCell.m
//  黑团HD
//
//  Created by apple on 14-8-19.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMDealCell.h"
#import "HMDeal.h"
#import <UIImageView+WebCache.h>

@interface HMDealCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *listPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchaseCountLabel;
/** 如果方法名以new、alloc、init开头，那么这些方法必须返回跟方法调用者同一类型的对象 */
@property (weak, nonatomic) IBOutlet UIImageView *dealNewMark;
/** 编辑时的遮盖 */
@property (weak, nonatomic) IBOutlet UIButton *cover;
/** 编辑时的打钩 */
@property (weak, nonatomic) IBOutlet UIImageView *checkmark;
@end

@implementation HMDealCell

- (void)setDeal:(HMDeal *)deal
{
    _deal = deal;
    
    // 图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:deal.image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    // 标题
    self.titleLabel.text = deal.title;
    // 描述
    self.descLabel.text = deal.desc;
    // 原价
    self.listPriceLabel.text = [NSString stringWithFormat:@"￥%@", deal.list_price];
    // 现价
    self.currentPriceLabel.text = [NSString stringWithFormat:@"￥%@", deal.current_price];
    // 购买数
    self.purchaseCountLabel.text = [NSString stringWithFormat:@"已售%d", deal.purchase_count];
    // 新单
    // 获得今天的年月日
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *now = [fmt stringFromDate:[NSDate date]];
    // 比较
    NSComparisonResult result = [now compare:deal.publish_date];
    self.dealNewMark.hidden = (result == NSOrderedDescending);
    
    // 根据模型的editing属性来确定是否要进入编辑模式
    self.cover.hidden = !deal.editing;
    
    // 根据模型的checked属性来确定是否要显示打钩（checkmark）
    self.checkmark.hidden = !self.deal.isChecked;
}

- (void)awakeFromNib
{
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dealcell"]];
}

- (IBAction)coverClick {
    // 永久修改模型状态
    self.deal.checked = !self.deal.isChecked;
    
    // 让打钩控件马上有反应
    self.checkmark.hidden = !self.deal.isChecked;
    
    // 发出通知
    [HMNoteCenter postNotificationName:HMCellCoverDidClickNotification object:nil];
}

@end
