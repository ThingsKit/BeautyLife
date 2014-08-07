//
//  BusinessDetailCell.m
//  BeautyLife
//
//  Created by mac on 14-8-7.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "BusinessDetailCell.h"

@implementation BusinessDetailCell

+ (id)inits
{
    UINib *nib = [UINib nibWithNibName:@"BusinessDetailCell" bundle:nil];
    BusinessDetailCell *cell = [nib instantiateWithOwner:self options:nil][0];
    
    return cell;
}

+ (NSString *)ID
{
    return @"BusinessDetailCell";
}
- (void)awakeFromNib
{
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
