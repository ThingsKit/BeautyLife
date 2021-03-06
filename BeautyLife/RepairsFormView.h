//
//  RepairsFormView.h
//  BeautyLife
//
//  Created by Seven on 14-8-2.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "EGOImageView.h"

@interface RepairsFormView : UIViewController<UIActionSheetDelegate, UIPickerViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, VPImageCropperDelegate>
{
    NSArray *cateData;
    NSTimer *_timer;
    UserModel *usermodel;
    NSString *cateValue;
    
    UIImage *picimage;
}

@property (strong, nonatomic) UIView *parentView;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UITextView *descTv;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;
@property (weak, nonatomic) IBOutlet UIButton *selectCateBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectPhoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

- (IBAction)selectTypeAction:(id)sender;
- (IBAction)selectPhoneAction:(id)sender;
- (IBAction)submitAction:(id)sender;

@end
