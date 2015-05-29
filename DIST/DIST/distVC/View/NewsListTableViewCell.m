//
//  NewsListTableViewCell.m
//  DIST
//
//  Created by AngelLL on 15/5/27.
//  Copyright (c) 2015年 大连科技学院. All rights reserved.
//

#import "NewsListTableViewCell.h"

@implementation NewsListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 3;
        _titleLabel.textColor = [UIColor colorFromHexCode:@"#464547"];
        [self.contentView addSubview:_titleLabel];
        
        self.dateLabel = [[UILabel alloc] init];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.font = [UIFont boldSystemFontOfSize:40];
        _dateLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_dateLabel];
        
        self.dayLabel = [[UILabel alloc] init];
        _dayLabel.text = @"日";
        _dayLabel.textAlignment = NSTextAlignmentRight;
        _dayLabel.font = [UIFont boldSystemFontOfSize:20];
        _dayLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_dayLabel];
        
        self.monthLabel = [[UILabel alloc] init];
        _monthLabel.textAlignment = NSTextAlignmentRight;
        _monthLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_monthLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = self.contentView.frame.size.width;
    CGFloat height = self.contentView.frame.size.height;
    
    _titleLabel.text = _info.title;
    _titleLabel.frame = CGRectMake(width / 3, 0, width * 2 / 3 - 20, height);
    
    NSArray *dateArr = [_info.date componentsSeparatedByString:@"-"];
    _dateLabel.text = [dateArr lastObject];
    _dateLabel.frame = CGRectMake(0, 0, width / 3, height);
    
    _dayLabel.frame = CGRectMake(0, height / 3, width / 3 - 14, height / 2);
    
    _monthLabel.text = [NSString stringWithFormat:@"%@/%@", [dateArr firstObject], [dateArr objectAtIndex:1]];
    _monthLabel.frame = CGRectMake(0, height * 2 / 3, width / 3 - 15, height / 3);
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
