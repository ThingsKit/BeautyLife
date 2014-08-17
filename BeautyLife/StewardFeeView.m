//
//  StewardFeeView.m
//  BeautyLife
//
//  Created by Seven on 14-8-1.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "StewardFeeView.h"

@interface StewardFeeView ()

@end

@implementation StewardFeeView

@synthesize scrollView;
@synthesize bgView;

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
    usermodel = [UserModel Instance];
    //用户是否已认证，已认证后才能报修
    if (![[usermodel getUserValueForKey:@"checkin"] isEqualToString:@"1"]) {
        self.payfeeBtn.enabled = NO;
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"温馨提醒"
                                                     message:@"您的入住信息暂未审核通过，暂未能在线费，请联系客户服务中心！"
                                                    delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
        [av show];
    }
    [Tool roundView:self.bgView andCornerRadius:3.0];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.view.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
