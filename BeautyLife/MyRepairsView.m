//
//  MyRepairsView.m
//  BeautyLife
//
//  Created by Seven on 14-8-4.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "MyRepairsView.h"

@interface MyRepairsView ()

@end

@implementation MyRepairsView

@synthesize bgView;
@synthesize myRepairsTable;

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
    self.myRepairsTable.dataSource = self;
    self.myRepairsTable.delegate = self;
    //    设置无分割线
    self.myRepairsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma TableView的处理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 96;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    cell.backgroundColor = [Tool getBackgroundColor];
}

//列表数据渲染
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyRepairsCell *cell = [tableView dequeueReusableCellWithIdentifier:MyRepairsCellIdentifier];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"MyRepairsCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[MyRepairsCell class]]) {
                cell = (MyRepairsCell *)o;
                break;
            }
        }
    }
    [Tool borderView:cell.bgLb];
    AMRatingControl *gradeControl = [[AMRatingControl alloc] initWithLocation:CGPointMake(0, 0)
                                                                           emptyColor:[UIColor colorWithRed:245.0/255 green:130.0/255 blue:33.0/255 alpha:1.0]
                                                                           solidColor:[UIColor colorWithRed:245.0/255 green:130.0/255 blue:33.0/255 alpha:1.0]
                                                                         andMaxRating:5  andStarSize:15 andStarWidthAndHeight:15];
    
    [gradeControl setRating:2];
    [cell.gradeLb addSubview:gradeControl];
    return cell;
}

//表格行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
