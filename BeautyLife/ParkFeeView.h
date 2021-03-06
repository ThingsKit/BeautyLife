//
//  ParkFeeView.h
//  BeautyLife
//
//  Created by Seven on 14-8-2.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface ParkFeeView : UIViewController<UIActionSheetDelegate, UIPickerViewDelegate>
{
    UserModel *usermodel;
    double monthFee;
    //应缴物业费
    double shouldMoney;
    //预缴物业费
    double presetMoney;
    NSArray *presetData;
    bool havePackFee;
}

@property (strong, nonatomic) UIView *parentView;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *telLb;
@property (weak, nonatomic) IBOutlet UIImageView *faceIv;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *parkInfoLb;
@property (weak, nonatomic) IBOutlet UILabel *shouldFeeLb;
@property (weak, nonatomic) IBOutlet UIButton *presetBtn;
@property (weak, nonatomic) IBOutlet UILabel *sumMoneyLb;
@property (weak, nonatomic) IBOutlet UIButton *payfeeBtn;

- (IBAction)showPresetAction:(id)sender;

@end
