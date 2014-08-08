//
//  BusinessDetailViewViewController.h
//  BeautyLife
//
//  Created by mac on 14-8-7.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessDetailView : UIViewController
{
    int cellIndex;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
