//
//  LifePageView.h
//  BeautyLife
//
//  Created by Seven on 14-7-30.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LifePageView : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *menuBg;
@property (strong, nonatomic) IBOutlet UILabel *telBg;

- (IBAction)clickService:(UIButton *)sender;

@end
