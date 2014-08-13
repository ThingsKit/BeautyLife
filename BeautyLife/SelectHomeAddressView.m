//
//  SelectHomeAddressView.m
//  BeautyLife
//
//  Created by Seven on 14-8-12.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "SelectHomeAddressView.h"

@interface SelectHomeAddressView ()

@end

@implementation SelectHomeAddressView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"住址选择";
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        self.navigationItem.titleView = titleLabel;
        
        UIButton *lBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [lBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [lBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
        UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithCustomView:lBtn];
        self.navigationItem.leftBarButtonItem = btnBack;
    }
    return self;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    AreaListModel *areaList = (AreaListModel *)[[EGOCache currentCache] objectForKey:AreaListKey];
    if (areaList == nil) {
        [self initAreaData];
    }
    else
    {
        areaData = areaList.areaList;
    }
}

- (void)initAreaData
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        NSString *url = [NSString stringWithFormat:@"%@%@?APPKey=%@", api_base_url, api_getregion, appkey];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try {
                                           areaData = [Tool readJsonStrToRegionArray:operation.responseString];
                                           AreaListModel *areaList = [[AreaListModel alloc] initWithParameters:areaData];
                                           [[EGOCache currentCache] setObject:areaList forKey:AreaListKey withTimeoutInterval:3600 * 24 *7];
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

- (IBAction)selectRegionAction:(id)sender {
    provinceArray = areaData;
    ProvinceModel *pro = (ProvinceModel *)[provinceArray objectAtIndex:0];
    cityArray = pro.cityArray;
    CityModel *city = (CityModel *)[cityArray objectAtIndex:0];
    regionArray = city.regionArray;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"确  定", nil];
    [actionSheet showInView:self.view];
    UIPickerView *cityPicker = [[UIPickerView alloc] init];
    cityPicker.delegate = self;
    cityPicker.showsSelectionIndicator = YES;
    cityPicker.tag = 0;
    [actionSheet addSubview:cityPicker];
}

//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView.tag == 0) {
        return 3;
    }
    else
    {
        return 0;
    }
}

//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView.tag == 0)
    {
        switch (component) {
            case 0:
                return [provinceArray count];
                break;
            case 1:
                return [cityArray count];
                break;
            case 2:
                return [regionArray count];
                break;
            default:
                return 0;
                break;
        }
    }
    else
    {
        return 0;
    }
}

#pragma mark Picker Delegate Methods

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView.tag == 0)
    {
        if (component == 0) {
            ProvinceModel *pro = (ProvinceModel *)[provinceArray objectAtIndex:row];
            return pro.name;
        }
        else if(component == 1) {
            CityModel *city = (CityModel *)[cityArray objectAtIndex:row];
            return city.name;
        }
        else if(component == 2) {
            RegionModel *region = (RegionModel *)[regionArray objectAtIndex:row];
            return region.name;
        }
        else
        {
            return nil;
        }
    }
    else
    {
        return nil;
    }
}

-(void) pickerView: (UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent: (NSInteger)component
{
    if(pickerView.tag == 0)
    {
        if (component == 0) {
            ProvinceModel *pro = (ProvinceModel *)[provinceArray objectAtIndex:row];
            cityArray = pro.cityArray;
            CityModel *city = (CityModel *)[cityArray objectAtIndex:0];
            regionArray = city.regionArray;
            [pickerView selectRow:0 inComponent:1 animated:NO];
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:2 animated:NO];
            [pickerView reloadComponent:2];
        }
        else if(component == 1) {
            CityModel *city = (CityModel *)[cityArray objectAtIndex:row];
            regionArray = city.regionArray;
            [pickerView selectRow:0 inComponent:2 animated:NO];
            [pickerView reloadComponent:2];
        }
        else if(component == 2) {

        }

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
