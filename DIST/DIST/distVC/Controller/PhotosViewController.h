//
//  PhotosViewController.h
//  DIST
//
//  Created by zhangjianhua on 15/4/17.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosViewController : UIViewController

@property (nonatomic, retain) NSMutableArray *arr;
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger top;

- (instancetype)initWithArray:(NSMutableArray *)array;
@end
