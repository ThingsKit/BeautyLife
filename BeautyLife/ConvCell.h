//
//  ConvCell.h
//  BeautyLife
//
//  Created by mac on 14-8-6.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConvCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *backgroudView;

+ (id)init;
+ (NSString *)ID;

@end
