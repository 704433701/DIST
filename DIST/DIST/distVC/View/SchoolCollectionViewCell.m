//
//  SchoolCollectionViewCell.m
//  DIST
//
//  Created by zhangjianhua on 15/4/16.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "SchoolCollectionViewCell.h"

@implementation SchoolCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 2;
        
        self.imgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgView];
        
        self.label = [[UILabel alloc] init];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
        _label.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        [self.contentView addSubview:_label];
        
    }
    return self;
}


- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    CGFloat width = layoutAttributes.frame.size.width;
    CGFloat height = layoutAttributes.frame.size.height;
    _scrollView.frame = CGRectMake(0, 0, width, height);
    _imgView.frame = CGRectMake(0, 0, width, height);
    _label.frame = CGRectMake(0, height - 30, width, 30);
}

- (void)setSchool:(NewsInfo *)school
{
    _school = school;
    [_imgView sd_setImageWithURL:_school.ID placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _label.text = _school.title;
}

@end
