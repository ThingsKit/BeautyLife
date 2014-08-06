//
//  MainPageView.m
//  BeautyLife
//
//  Created by Seven on 14-7-29.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "MainPageView.h"
#import "ConvView.h"
#import "ConvOrderView.h"
#import "RechargeView.h"
#import "SubtleView.h"
#import "BusinessView.h"

@interface MainPageView ()

@end

@implementation MainPageView

@synthesize scrollView;
@synthesize menuBg;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.view.frame.size.height);
    [Tool roundView:self.menuBg andCornerRadius:3.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //即使没有显示在window上，也不会自动的将self.view释放。
    // Add code to clean up any of your own resources that are no longer necessary.
    
    // 此处做兼容处理需要加上ios6.0的宏开关，保证是在6.0下使用的,6.0以前屏蔽以下代码，否则会在下面使用self.view时自动加载viewDidUnLoad
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        //需要注意的是self.isViewLoaded是必不可少的，其他方式访问视图会导致它加载 ，在WWDC视频也忽视这一点。
        if (self.isViewLoaded && !self.view.window)// 是否是正在使用的视图
        {
            // Add code to preserve data stored in the views that might be
            // needed later.
            
            // Add code to clean up other strong references to the view in
            // the view hierarchy.
            self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (IBAction)clickService:(UIButton *)sender
{
    ConvOrderView *convView = [[ConvOrderView alloc] init];
    convView.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:convView animated:YES];
}

- (IBAction)clickRecharge:(UIButton *)sender
{
    RechargeView *rechargeView = [[RechargeView alloc] init];
    rechargeView.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:rechargeView animated:YES];
}

- (IBAction)stewardFeeAction:(id)sender {
    StewardFeeFrameView *feeFrame = [[StewardFeeFrameView alloc] init];
    feeFrame.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:feeFrame animated:YES];
}

- (IBAction)repairsAction:(id)sender {
    RepairsFrameView *repairsFrame = [[RepairsFrameView alloc] init];
    repairsFrame.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:repairsFrame animated:YES];
}

- (IBAction)noticeAction:(id)sender {
    NoticeFrameView *noticeFrame = [[NoticeFrameView alloc] init];
    noticeFrame.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:noticeFrame animated:YES];
}

- (IBAction)expressAction:(id)sender {
    ExpressView *expressView = [[ExpressView alloc] init];
    expressView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:expressView animated:YES];
}
@end
