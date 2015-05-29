//
//  MenuCollectionViewCell.m
//  DIST
//
//  Created by lanou3g on 15/5/15.
//  Copyright (c) 2015年 大连科技学院. All rights reserved.
//

#import "MenuCollectionViewCell.h"

@implementation MenuCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageView];
        
        self.label = [[UILabel alloc] init];
        _label.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_label];
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    CGFloat width = layoutAttributes.frame.size.width;
    CGFloat height = layoutAttributes.frame.size.height;
    _imageView.frame = CGRectMake(10, 0, width - 20, width - 20);
    _label.frame = CGRectMake(0, width - 20, width, height - width + 20);
    _label.layer.cornerRadius = (height - width + 20) / 2;
    _label.clipsToBounds = YES;
}
@end
