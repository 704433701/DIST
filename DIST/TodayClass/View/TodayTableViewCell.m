//
//  TodayTableViewCell.m
//  DIST
//
//  Created by lanou3g on 15/5/9.
//  Copyright (c) 2015年 大连科技学院. All rights reserved.
//

#import "TodayTableViewCell.h"

@implementation TodayTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.courseLabel = [[UILabel alloc] init];
        _courseLabel.font = [UIFont systemFontOfSize:18];
        _courseLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_courseLabel];
        
        self.classroomLabel = [[UILabel alloc] init];
        _classroomLabel.font = [UIFont systemFontOfSize:13];
        _classroomLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_classroomLabel];
        
        self.timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_timeLabel];
        
        self.timeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-shijian.png"]];
        [self.contentView addSubview:_timeImage];
        
        self.classroomImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-didian.png"]];
        [self.contentView addSubview:_classroomImage];
                
    }
    return self;
}

- (void)layoutSubviews
{
    CGFloat width = self.contentView.frame.size.width;
    CGFloat height = self.contentView.frame.size.height;
    
    _courseLabel.frame = CGRectMake(0, 0, width, height / 2);
    _courseLabel.text = _classTable.course;
    
    _classroomLabel.frame = CGRectMake(width / 2 + height / 8, height / 2, width / 3, height / 2);
    _classroomLabel.text = _classTable.classroom;
    _classroomImage.frame = CGRectMake(width / 2 - height / 4, height / 2 + 3, height / 2 - 6, height / 2 - 6);
    
    _timeLabel.frame = CGRectMake(height / 2, height / 2, width * 2 / 3, height / 2);
    _timeLabel.text = _classTable.time;
    _timeImage.frame = CGRectMake(0, height / 2 + 4, height / 2 - 8, height / 2 - 8);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
