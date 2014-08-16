//
//  BusinessCell.m
//  BeautyLife
//
//  Created by mac on 14-8-7.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "BusinessCell.h"

@implementation BusinessCell
+ (id)initWith
{
    UINib *nib = [UINib nibWithNibName:@"BusinessCell" bundle:nil];
    BusinessCell *cell = [nib instantiateWithOwner:nil options:nil][0];
    
    //将图层的边框设置为圆脚
    cell.cellbackgroudView.layer.cornerRadius = 5;
    cell.cellbackgroudView.layer.masksToBounds = YES;
    return cell;
}

+ (NSString *)ID
{
    return @"BusinessCell";
}
- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}
@end
