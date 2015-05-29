//
//  ScoreTableViewCell.m
//  DIST
//
//  Created by AngelLL on 15/5/25.
//  Copyright (c) 2015年 大连科技学院. All rights reserved.
//

#import "ScoreTableViewCell.h"

@implementation ScoreTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.courseLabel = [[UILabel alloc] init];
        _courseLabel.font = [UIFont boldSystemFontOfSize:20];
        [self.contentView addSubview:_courseLabel];
        
        self.ysscoreLabel = [[UILabel alloc] init];
        _ysscoreLabel.textAlignment = NSTextAlignmentCenter;
        _ysscoreLabel.font = [UIFont boldSystemFontOfSize:24];
        [self.contentView addSubview:_ysscoreLabel];
        
        self.teacherLabel = [[UILabel alloc] init];
        _teacherLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_teacherLabel];
        
        self.stateLabel = [[UILabel alloc] init];
        _stateLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_stateLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = self.contentView.frame.size.width;
    CGFloat height = self.contentView.frame.size.height;
    _courseLabel.frame = CGRectMake(20, 0, width * 3 / 4, height * 2 / 3);
    _courseLabel.text = _score.courseName;
    
    _ysscoreLabel.frame = CGRectMake(width * 3 / 4 + 20, 0, width / 4 - 20, height);
    _ysscoreLabel.text = _score.YSscore;
    if (_score.YSscore.integerValue < 60 && _score.YSscore.integerValue > 0) {
        _ysscoreLabel.textColor = [UIColor redColor];
    } else {
        _ysscoreLabel.textColor = [UIColor greenSeaColor];
    }
//    NSLog(@"%@", _score.teacher);
    _teacherLabel.frame = CGRectMake(20, height * 2 / 3, width * 3 / 4 / 2, height / 3);
    _teacherLabel.text = _score.teacher;
    
    _stateLabel.frame = CGRectMake(width * 3 / 4 / 2 + 20, height * 2 / 3, width * 3 / 4 / 2, height / 3);
    _stateLabel.text = _score.state;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
