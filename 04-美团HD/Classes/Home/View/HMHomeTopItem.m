//
//  HMHomeTopItem.m
//  美团HD
//
//  Created by apple on 14/11/23.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMHomeTopItem.h"

@interface HMHomeTopItem()
/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 子标题 */
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
/** 图标按钮 */
@property (weak, nonatomic) IBOutlet UIButton *iconButton;
@end

@implementation HMHomeTopItem
+ (instancetype)item
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HMHomeTopItem" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)setSubtitle:(NSString *)subtitle
{
    self.subtitleLabel.text = subtitle;
}

- (void)setIcon:(NSString *)icon highIcon:(NSString *)highIcon
{
    [self.iconButton setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [self.iconButton setImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];
}

- (void)addTarget:(id)target action:(SEL)action
{
    [self.iconButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
@end
