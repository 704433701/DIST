//
//  SchoolBigCollectionViewCell.h
//  DIST
//
//  Created by lanou3g on 15/4/28.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VIPhotoView.h"
#import "NewsInfo.h"

@interface SchoolBigCollectionViewCell : UICollectionViewCell

@property (nonatomic, retain) VIPhotoView *photoView;
@property (nonatomic, retain) NewsInfo *school;
@end
