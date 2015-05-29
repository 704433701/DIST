//
//  SchoolCollectionViewCell.h
//  DIST
//
//  Created by zhangjianhua on 15/4/16.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsInfo.h"

@interface SchoolCollectionViewCell : UICollectionViewCell

@property (nonatomic, retain) UIImageView *imgView;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) NewsInfo *school;
@property (nonatomic, retain) UIScrollView *scrollView;

@end
