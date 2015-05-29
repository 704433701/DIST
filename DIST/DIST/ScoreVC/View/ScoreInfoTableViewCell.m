//
//  ScoreInfoTableViewCell.m
//  DIST
//
//  Created by AngelLL on 15/5/26.
//  Copyright (c) 2015年 大连科技学院. All rights reserved.
//

#import "ScoreInfoTableViewCell.h"

@implementation ScoreInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imgView];
        
        self.attributeLabel = [[UILabel alloc] init];
        _attributeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_attributeLabel];
        
        self.infoLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_infoLabel];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = self.contentView.frame.size.width;
    CGFloat height = self.contentView.frame.size.height;
    
    _imgView.frame = CGRectMake(0, 0, width / 7, height + 2);
    _imgView.image = [UIImage imageNamed:@"scoreInfo"];
    
    _attributeLabel.frame = CGRectMake(width / 7, 0, width * 2 / 7 - 10 , height);
    
    _infoLabel.frame = CGRectMake(width * 3 / 7, 0, width * 4 / 7 - 10, height);
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
