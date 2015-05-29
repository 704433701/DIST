//
//  ExamTableViewCell.h
//  DIST
//
//  Created by lanou3g on 15/5/11.
//  Copyright (c) 2015年 大连科技学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamInfo.h"

@interface ExamTableViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) ExamInfo *info;
@end
