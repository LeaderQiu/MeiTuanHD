//
//  HMDropdownLeftCell.m
//  04-美团HD
//
//  Created by apple on 15/2/4.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "HMDropdownLeftCell.h"

@implementation HMDropdownLeftCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *leftId = @"left";
    HMDropdownLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:leftId];
    if (cell == nil) {
        cell = [[HMDropdownLeftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftId];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_leftpart"]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_left_selected"]];
    }
    return cell;
}
@end
