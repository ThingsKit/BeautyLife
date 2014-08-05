//
//  NewsTableView.h
//  BeautyLife
//
//  Created by Seven on 14-8-5.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeTableCell.h"

@interface NewsTableView : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *newsTable;

@end
