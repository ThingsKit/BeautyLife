//
//  ParkFeeView.m
//  BeautyLife
//
//  Created by Seven on 14-8-2.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "ParkFeeView.h"

@interface ParkFeeView ()

@end

@implementation ParkFeeView

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
    [Tool roundView:self.bgView andCornerRadius:3.0];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.view.frame.size.height);
    
    usermodel = [UserModel Instance];
    self.nameLb.text = [usermodel getUserValueForKey:@"name"];
    
    EGOImageView *faceEGOImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"userface.png"]];
    faceEGOImageView.imageURL = [NSURL URLWithString:[[UserModel Instance] getUserValueForKey:@"avatar"]];
    faceEGOImageView.frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    [self.faceIv addSubview:faceEGOImageView];
    [self getParkFee];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlertView) name:Notification_ShowPackAlertView object:nil];
}

- (void)getParkFee
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        NSString *url = [NSString stringWithFormat:@"%@%@?APPKey=%@&userid=%@", api_base_url, api_myparkfee, appkey, [[UserModel Instance] getUserValueForKey:@"id"]];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try {
//                                           PropertyFeeInfo *feeInfo = [Tool readJsonStrToPropertyFeeInfo:operation.responseString];
                                           NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                                           NSError *error;
                                           NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                           if (!json) {
                                               self.payfeeBtn.enabled = NO;
                                               havePackFee = NO;
                                           }
                                           else
                                           {
                                               havePackFee = YES;
                                               NSMutableArray *feeInfoArray = [Tool readJsonStrToPropertyCarFeeInfo:operation.responseString];
                                               if (feeInfoArray != nil && [feeInfoArray count] > 0) {
                                                   CarFeeInfo *feeInfo = (CarFeeInfo *)[feeInfoArray objectAtIndex:0];
                                                   NSString *carport_number = feeInfo.carport_number;
                                                   if ([carport_number isEqualToString:@"NT"]) {
                                                       carport_number = @"租用车位";
                                                   }
                                                   self.parkInfoLb.text = [NSString stringWithFormat:@"%@  %@  %@", [usermodel getUserValueForKey:@"tel"], feeInfo.car_number, carport_number];
                                                   
                                                   monthFee = [feeInfo.park_fee doubleValue] * [feeInfo.discount doubleValue];
                                                   //获得已缴月份
                                                   int endFeeMonth = [[feeInfo.fee_enddate substringWithRange:NSMakeRange(0, 4)] intValue] *12 + [[feeInfo.fee_enddate substringWithRange:NSMakeRange(5, 2)] intValue];
                                                   //获得当前月份
                                                   NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                                   [formatter setDateFormat:@"YYYY-MM"];
                                                   NSString *currentMonthStr = [formatter stringFromDate:[NSDate date]];
                                                   int currentMonth = [[currentMonthStr substringWithRange:NSMakeRange(0, 4)] intValue] *12 + [[currentMonthStr substringWithRange:NSMakeRange(5, 2)] intValue];
                                                   
                                                   if ( (currentMonth - endFeeMonth) > 0) {
                                                       shouldMoney = monthFee * (currentMonth - endFeeMonth);
                                                   }
                                                   else
                                                   {
                                                       shouldMoney = 0.00;
                                                   }
                                                   self.shouldFeeLb.text = [NSString stringWithFormat:@"￥%0.2f元", shouldMoney];
                                                   
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
                                                   presetMoney = [[preset objectForKey:@"money"] doubleValue];
                                                   [self.presetBtn setTitle:[preset objectForKey:@"text"] forState:UIControlStateNormal];
                                               }
                                           }
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

-(void)showAlertView
{
    if (!havePackFee) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"温馨提醒"
                                                     message:@"没有找到您的车辆信息!"
                                                    delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
        [av show];
    }
}

- (IBAction)showPresetAction:(id)sender
{
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

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 0) {
        if (buttonIndex == 0) {
            double sumMoney = shouldMoney + presetMoney;
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
    presetMoney = [[preset objectForKey:@"money"] doubleValue];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
