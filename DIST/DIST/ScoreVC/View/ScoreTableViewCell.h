//
//  ScoreTableViewCell.h
//  DIST
//
//  Created by AngelLL on 15/5/25.
//  Copyright (c) 2015年 大连科技学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Score.h"

@interface ScoreTableViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *courseLabel;
@property (nonatomic, retain) UILabel *ysscoreLabel;
@property (nonatomic, retain) UILabel *teacherLabel;
@property (nonatomic, retain) UILabel *stateLabel;

@property (nonatomic, retain) Score *score;
@end
