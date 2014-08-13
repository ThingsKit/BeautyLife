//
//  SelectHomeAddressView.h
//  BeautyLife
//
//  Created by Seven on 14-8-12.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOCache.h"
#import "AreaListModel.h"
#import "ProvinceModel.h"
#import "CityModel.h"
#import "RegionModel.h"

@interface SelectHomeAddressView : UIViewController< UIActionSheetDelegate, UIPickerViewDelegate>
{
    NSArray *areaData;
    
    NSArray *provinceArray;
    NSArray *cityArray;
    NSArray *regionArray;
}

- (IBAction)selectRegionAction:(id)sender;

@end
