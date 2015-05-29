//
//  ExamTableViewCell.m
//  DIST
//
//  Created by lanou3g on 15/5/11.
//  Copyright (c) 2015年 大连科技学院. All rights reserved.
//

#import "ExamTableViewCell.h"

@implementation ExamTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.numberOfLines = 0;
        [self.contentView addSubview:_titleLabel];
        
        self.timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_timeLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    _titleLabel.text = _info.title;
    _titleLabel.frame = CGRectMake(20, 0, self.contentView.frame.size.width * 3 / 4, self.contentView.frame.size.height);
    
    _timeLabel.textColor = [UIColor greenSeaColor];
    if (_info.time.integerValue < 10) {
        _timeLabel.textColor = [UIColor redColor];
    }
    _timeLabel.text = _info.time;
    _timeLabel.frame = CGRectMake(self.contentView.frame.size.width * 3 / 4 + 20, 0, self.contentView.frame.size.width / 4 - 40, self.contentView.frame.size.height);
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
