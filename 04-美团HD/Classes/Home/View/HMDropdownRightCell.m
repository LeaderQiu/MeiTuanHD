//
//  HMDropdownRightCell.m
//  04-美团HD
//
//  Created by apple on 15/2/4.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "HMDropdownRightCell.h"

@implementation HMDropdownRightCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *rightId = @"right";
    HMDropdownRightCell *cell = [tableView dequeueReusableCellWithIdentifier:rightId];
    if (cell == nil) {
        cell = [[HMDropdownRightCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightId];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_rightpart"]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_right_selected"]];
    }

    return cell;
}
@end
