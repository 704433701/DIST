//
//  HeaderCollectionViewCell.m
//  DIST
//
//  Created by lanou3g on 15/5/5.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "HeaderCollectionViewCell.h"

@implementation HeaderCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc] init];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont boldSystemFontOfSize:17.0f];
        [self.contentView addSubview:_label];
        
        self.view = [[UIView alloc] init];
        _view.backgroundColor = [UIColor whiteColor];
        _view.layer.cornerRadius = 11;
        [self.contentView addSubview:_view];
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    _label.frame = CGRectMake(0, 0, layoutAttributes.frame.size.width, layoutAttributes.frame.size.height);
    _view.frame = CGRectMake(0, layoutAttributes.frame.size.height * 9 / 10, layoutAttributes.frame.size.width, layoutAttributes.frame.size.height / 10);
}
@end
