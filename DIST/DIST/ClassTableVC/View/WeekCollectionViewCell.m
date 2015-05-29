//
//  WeekCollectionViewCell.m
//  DIST
//
//  Created by lanou3g on 15/5/5.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "WeekCollectionViewCell.h"

@implementation WeekCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        _imageView.layer.cornerRadius = 10;
        _imageView.backgroundColor = ClassTable_Color;
        [self.contentView addSubview:_imageView];
        self.label = [[UILabel alloc] init];
        _label.numberOfLines = 0;
     //   _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:14];
        _label.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_label];
    }
    return self;
}
- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    _imageView.frame = CGRectMake(1, 1, layoutAttributes.frame.size.width - 2, layoutAttributes.frame.size.height - 2);
    _label.frame = CGRectMake(1, 1, layoutAttributes.frame.size.width - 2, layoutAttributes.frame.size.height - 2);
}
@end
