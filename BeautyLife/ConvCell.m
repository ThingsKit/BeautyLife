//
//  ConvCell.m
//  BeautyLife
//
//  Created by mac on 14-8-6.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "ConvCell.h"

@implementation ConvCell

+ (id)init
{
    UINib *nib = [UINib nibWithNibName:@"ConvCell" bundle:nil];
    ConvCell *cell = [nib instantiateWithOwner:nil options:nil][0];
    
    //将图层的边框设置为圆脚
    cell.backgroudView.layer.cornerRadius = 8;
    cell.backgroudView.layer.masksToBounds = YES;
    return cell;
}

+ (NSString *)ID
{
    return @"ConvCell";
}
- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
