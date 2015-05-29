//
//  SchoolBigCollectionViewCell.m
//  DIST
//
//  Created by lanou3g on 15/4/28.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "SchoolBigCollectionViewCell.h"


@implementation SchoolBigCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setSchool:(NewsInfo *)school
{
    _school = school;

    if (_photoView != nil) {
        [_photoView removeFromSuperview];
    }
    self.photoView = [[VIPhotoView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:_photoView];
    [self.photoView.imageView sd_setImageWithURL:self.school.ID placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.photoView size];
    }];
}
@end
