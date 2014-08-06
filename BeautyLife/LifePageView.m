//
//  LifePageView.m
//  BeautyLife
//
//  Created by Seven on 14-7-30.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "LifePageView.h"
#import "ConvView.h"
#import "RechargeView.h"
#import "SubtleView.h"
#import "BusinessView.h"

@interface LifePageView ()

@end

@implementation LifePageView

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

- (IBAction)clickService:(UIButton *)sender
{
    ConvView *convView = [[ConvView alloc] init];
    convView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:convView animated:YES];
}

- (IBAction)clickRecharge:(UIButton *)sender
{
    RechargeView *rechargeView = [[RechargeView alloc] init];
    rechargeView.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:rechargeView animated:YES];
}

- (IBAction)clickSubtle:(UIButton *)sender
{
    SubtleView *subtleView = [[SubtleView alloc] init];
    subtleView.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:subtleView animated:YES];
}

- (IBAction)clickBusiness:(UIButton *)sender
{
    BusinessView *businessView = [[BusinessView alloc] init];
    businessView.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:businessView animated:YES];
}
@end
