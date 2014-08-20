//
//  StewardFeeView.m
//  BeautyLife
//
//  Created by Seven on 14-8-1.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "StewardFeeView.h"
#import "DataSigner.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "AlixPayOrder.h"
#import "AlipayUtils.h"
#import "PayOrder.h"

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
    else
    {
        [self getPropertyFee];
    }
    [Tool roundView:self.bgView andCornerRadius:3.0];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.view.frame.size.height);
    
    self.nameLb.text = [usermodel getUserValueForKey:@"name"];
    EGOImageView *faceEGOImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"userface.png"]];
    faceEGOImageView.imageURL = [NSURL URLWithString:[[UserModel Instance] getUserValueForKey:@"avatar"]];
    faceEGOImageView.frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    [self.faceIv addSubview:faceEGOImageView];
}

- (void)getPropertyFee
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        NSString *url = [NSString stringWithFormat:@"%@%@?APPKey=%@&userid=%@", api_base_url, api_mypropertyfee, appkey, [[UserModel Instance] getUserValueForKey:@"id"]];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try {
                                           PropertyFeeInfo *feeInfo = [Tool readJsonStrToPropertyFeeInfo:operation.responseString];
                                           
                                           self.userInfoLb.text = [NSString stringWithFormat:@"%@  %@(%@㎡)", [usermodel getUserValueForKey:@"tel"], feeInfo.house_number, feeInfo.area];
                                           
                                           monthFee = [feeInfo.area doubleValue] * [feeInfo.property_fee doubleValue] * [feeInfo.discount doubleValue];
                                           //获得已缴月份
                                           int endFeeMonth = [[feeInfo.fee_enddate substringWithRange:NSMakeRange(0, 4)] intValue] *12 + [[feeInfo.fee_enddate substringWithRange:NSMakeRange(5, 2)] intValue];
                                           //获得当前月份
                                           NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                           [formatter setDateFormat:@"YYYY-MM"];
                                           NSString *currentMonthStr = [formatter stringFromDate:[NSDate date]];
                                           int currentMonth = [[currentMonthStr substringWithRange:NSMakeRange(0, 4)] intValue] *12 + [[currentMonthStr substringWithRange:NSMakeRange(5, 2)] intValue];
                                           
                                           if ( (currentMonth - endFeeMonth) > 0) {
                                               arrearage = monthFee * (currentMonth - endFeeMonth);
                                           }
                                           else
                                           {
                                               arrearage = 0.00;
                                           }
                                           self.shouldPayLb.text = [NSString stringWithFormat:@"￥%0.2f元", arrearage];
                                           self.sumMoneyLb.text = [NSString stringWithFormat:@"￥%0.2f元", arrearage];
                                           
                                           //不预交字典
                                           NSDictionary *preset0 = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                    @"0.00", @"money",
                                                                    @"不预缴", @"text", nil];
                                           //季度预交字典，季度98折优惠
                                           double month3Fee = monthFee * 3 * 0.98;
                                           NSDictionary *preset1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                    [Tool notRounding:month3Fee afterPoint:2], @"money",
                                                                    [NSString stringWithFormat:@"预缴一季度（9.8折优惠，%@元）", [Tool notRounding:month3Fee afterPoint:2]], @"text", nil];
                                           //半年预交字典，半年95折优惠
                                           double month6Fee = monthFee * 6 * 0.95;
                                           NSDictionary *preset2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                    [Tool notRounding:month6Fee afterPoint:2], @"money",
                                                                    [NSString stringWithFormat:@"预缴半年（9.5折优惠，%@元）", [Tool notRounding:month6Fee afterPoint:2]], @"text", nil];
                                           //一年预交字典，半年9折优惠
                                           double month12Fee = monthFee * 12 * 0.9;
                                           NSDictionary *preset3 = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                    [Tool notRounding:month12Fee afterPoint:2], @"money",
                                                                    [NSString stringWithFormat:@"预缴一年（9折优惠，%@元）", [Tool notRounding:month12Fee afterPoint:2]], @"text", nil];
                                           presetData = [[NSArray alloc] initWithObjects:preset0, preset1, preset2, preset3, nil];
                                           
                                           NSDictionary *preset = (NSDictionary *)[presetData objectAtIndex:0];
                                           presetValue = [[preset objectForKey:@"money"] doubleValue];
                                           [self.presetBtn setTitle:[preset objectForKey:@"text"] forState:UIControlStateNormal];
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {
                                           
                                       }
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       if ([UserModel Instance].isNetworkRunning == NO) {
                                           return;
                                       }
                                       if ([UserModel Instance].isNetworkRunning) {
                                           [Tool ToastNotification:@"错误 网络无连接" andView:self.view andLoading:NO andIsBottom:NO];
                                       }
                                   }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showPresetAction:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"确  定", nil];
    actionSheet.tag = 0;
    [actionSheet showInView:self.parentView];
    UIPickerView *catePicker = [[UIPickerView alloc] init];
    catePicker.delegate = self;
    catePicker.showsSelectionIndicator = YES;
    [actionSheet addSubview:catePicker];
}

#pragma mark 付费按钮事件处理
- (IBAction)payFeeAction:(UIButton *)sender
{
    PayOrder *pro = [[PayOrder alloc] init];
    pro.subject = @"美世界物业费";
    pro.body = @"美世界物业费在线缴纳,是美世界公司针对业主提供的便民服务,采用支付宝进行付费";
    pro.price = 0.01;
    pro.partnerID = @"2088511309376197";
    pro.partnerPrivKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBANOdyYRppMpdZI0JNEMmNA2yo0HkaP9KjcBtzvg12DmYXlQwqERSKG5ybkbiTbnow9YeE/+rjxfHMegz8ja1Q+6/1E2BTmHZItYP/2x3faD+oDLarlCuCA1NEf7qvgKIedw5kNTiAmDZtc3uaau3inZ6g9leWvBrYPJW4IdcqPmZAgMBAAECgYEAt1L/S/XVa/aCcGgj3XRQLfmu0xuUFm245ZZ7ca371tF4DolkjGN8YUpC3KeaXE8YsPq3qosuWJQZWSb/U4OvB6etpwu5aFOKd6E3D0FZqm1nfQFl9FlfalO6qiVnmJEAlEF9SYuRoDEYrGr4cFT27BB6f8dSIHd8nR6ztKYmcO0CQQDwX0dsnyMnu4YpV7aLJRL8QvBuU1NdigVAXmkzBnACRzgSKjwNp1dP6posxcfQA0pTTM7irm5/aonkrjc8nyYXAkEA4V/mc+nEb3pe+eINAjurwB44ryzEw+bj5UUlU0i/56VwnGTf18N/vBDFBnwS/YfqlMOHDN+8SvZ9rXtkymlbzwJAJL1bbGXSeMM32V/XveLXyQjuON6xkk2DSfhkOfFU83QxRM2BylB2jvd7wzYjuU6XcK3/vTQOHZmKJBLgzHpC1wJAOJxsOMWJkC7+2GnNtrfiZnmw51+pdUP0Ds0VmRv3CGroJIC6MWpsFYNo2j4kTwbrB78tlzBEDdhorUEHikh4xQJARuQ3Gs+a3/aYcUejhpSDiG6xdfhhFDBgMfpkauUvaZQB0OwTYMD6zDYvh+QHeEhAU4+jX5CM1HJchp9MMRS2Zw==";
    pro.sellerID = @"meishenghuo@mmshijie.com";
    
    [AlipayUtils doPay:pro AndScheme:@"BeautyLifeAlipay" seletor:nil target:nil];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 0) {
        if (buttonIndex == 0) {
            double sumMoney = arrearage + presetValue;
            self.sumMoneyLb.text = [NSString stringWithFormat:@"￥%0.2f元", sumMoney];
        }
    }
}

//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [presetData count];
}

#pragma mark Picker Delegate Methods

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *preset = (NSDictionary *)[presetData objectAtIndex:row];
    return [preset objectForKey:@"text"];
}

-(void) pickerView: (UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent: (NSInteger)component
{
    NSDictionary *preset = (NSDictionary *)[presetData objectAtIndex:row];
    presetValue = [[preset objectForKey:@"money"] doubleValue];
    [self.presetBtn setTitle:[preset objectForKey:@"text"] forState:UIControlStateNormal];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 300, 30)];
    myView.textAlignment = UITextAlignmentCenter;
    NSDictionary *preset = (NSDictionary *)[presetData objectAtIndex:row];
    myView.text = [preset objectForKey:@"text"];
    myView.font = [UIFont systemFontOfSize:16];         //用label来设置字体大小
    myView.backgroundColor = [UIColor clearColor];
    return myView;
}

@end
