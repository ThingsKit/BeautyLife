//
//  MainPageView.h
//  BeautyLife
//
//  Created by Seven on 14-7-29.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainPageView : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *menuBg;

- (IBAction)clickService:(UIButton *)sender;

- (IBAction)clickRecharge:(UIButton *)sender;

@end
