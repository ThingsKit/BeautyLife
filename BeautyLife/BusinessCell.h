//
//  BusinessCell.h
//  BeautyLife
//
//  Created by mac on 14-8-7.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *cellbackgroudView;

+ (id)initWith;
+ (NSString *)ID;

@end