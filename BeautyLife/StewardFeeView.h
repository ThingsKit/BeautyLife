//
//  StewardFeeView.h
//  BeautyLife
//
//  Created by Seven on 14-8-1.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StewardFeeView : UIViewController
{
    UserModel *usermodel;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *payfeeBtn;

@end
