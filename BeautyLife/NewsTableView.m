//
//  NewsTableView.m
//  BeautyLife
//
//  Created by Seven on 14-8-5.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "NewsTableView.h"

@interface NewsTableView ()

@end

@implementation NewsTableView

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
    self.newsTable.dataSource = self;
    self.newsTable.delegate = self;
//    self.view.backgroundColor = [Tool getBackgroundColor];
    //    设置无分割线
    self.newsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma TableView的处理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 82;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    cell.backgroundColor = [Tool getBackgroundColor];
}

//列表数据渲染
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NoticeTableCellIdentifier];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"NoticeTableCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[NoticeTableCell class]]) {
                cell = (NoticeTableCell *)o;
                break;
            }
        }
    }
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
