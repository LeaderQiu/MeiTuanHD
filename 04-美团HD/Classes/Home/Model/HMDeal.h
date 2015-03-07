//
//  HMDeal.h
//  04-美团HD
//
//  Created by apple on 15/2/5.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HMRestrictions;

@interface HMDeal : NSObject <NSCoding>
/** 团购单ID */
@property (copy, nonatomic) NSString *deal_id;
/** 团购标题 */
@property (copy, nonatomic) NSString *title;
/** 团购描述 */
@property (copy, nonatomic) NSString *desc;
/** 如果想完整保留服务器的返回数值，就不要用基本数据类型，建议使用NSString或者NSNumber*/
/** 团购包含商品原价值 */
@property (copy, nonatomic) NSString *list_price;
/** 团购价格 */
@property (copy, nonatomic) NSString *current_price;
/** 团购当前已购买数 */
@property (assign, nonatomic) int purchase_count;

/** 团购图片链接，最大图片尺寸450×280 */
@property (copy, nonatomic) NSString *image_url;
/** 小尺寸团购图片链接，最大图片尺寸160×100 */
@property (copy, nonatomic) NSString *s_image_url;

/** 团购发布上线日期 */
@property (copy, nonatomic) NSString *publish_date;
/** 团购单的截止购买日期 */
@property (copy, nonatomic) NSString *purchase_deadline;

/** 团购Web页面链接，适用于网页应用 */
@property (copy, nonatomic) NSString *deal_url;
/** 团购HTML5页面链接，适用于移动应用和联网车载应用 */
@property (copy, nonatomic) NSString *deal_h5_url;

/** 是否支持随时退款，0：不是，1：是 */
@property (nonatomic, assign) BOOL is_refundable;

/** 控制cell的状态 */
@property (nonatomic, assign, getter=isEditing) BOOL editing;
@property (nonatomic, assign, getter=isChecked) BOOL checked;
@end
