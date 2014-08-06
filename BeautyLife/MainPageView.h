//
//  MainPageView.h
//  BeautyLife
//
//  Created by Seven on 14-7-29.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StewardFeeFrameView.h"
#import "RepairsFrameView.h"
#import "NoticeFrameView.h"
#import "ExpressView.h"


@interface MainPageView : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *menuBg;

#pragma mark -按钮点击事件

#pragma mark 便民服务
- (IBAction)clickService:(UIButton *)sender;

#pragma mark 在线充值
- (IBAction)clickRecharge:(UIButton *)sender;

- (IBAction)stewardFeeAction:(id)sender;
- (IBAction)repairsAction:(id)sender;
- (IBAction)noticeAction:(id)sender;
- (IBAction)expressAction:(id)sender;
#pragma mark 精选特价
- (IBAction)clickSubtle:(UIButton *)sender;

#pragma mark 联盟商家
- (IBAction)clickBusiness:(UIButton *)sender;
@end
