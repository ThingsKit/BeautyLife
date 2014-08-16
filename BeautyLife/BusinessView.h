//
//  ConvView.h
//  BeautyLife
//
//  Created by mac on 14-7-31.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface BusinessView : UIViewController<UITableViewDelegate,UITableViewDataSource,BMKLocationServiceDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
