//
//  StewardPageView.m
//  BeautyLife
//
//  Created by Seven on 14-7-29.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "StewardPageView.h"

@interface StewardPageView ()

@end

@implementation StewardPageView

@synthesize scrollView;

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
    [Tool roundView:self.telBg andCornerRadius:3.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (IBAction)stewardFeeAction:(id)sender {
    StewardFeeFrameView *feeFrame = [[StewardFeeFrameView alloc] init];
    [self.navigationController pushViewController:feeFrame animated:YES];
}

- (IBAction)repairsAction:(id)sender {
    RepairsFrameView *repairsFrame = [[RepairsFrameView alloc] init];
    [self.navigationController pushViewController:repairsFrame animated:YES];
}

- (IBAction)noticeAction:(id)sender {
    NoticeFrameView *noticeFrame = [[NoticeFrameView alloc] init];
    [self.navigationController pushViewController:noticeFrame animated:YES];
}

- (IBAction)expressAction:(id)sender {
    ExpressView *expressView = [[ExpressView alloc] init];
    [self.navigationController pushViewController:expressView animated:YES];
}
@end
