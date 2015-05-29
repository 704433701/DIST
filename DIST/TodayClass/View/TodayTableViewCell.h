//
//  TodayTableViewCell.h
//  DIST
//
//  Created by lanou3g on 15/5/9.
//  Copyright (c) 2015年 大连科技学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassTable.h"

@interface TodayTableViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *courseLabel;
@property (nonatomic, retain) UILabel *classroomLabel;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) ClassTable *classTable;
@property (nonatomic, retain) UIImageView *timeImage;
@property (nonatomic, retain) UIImageView *classroomImage;
@end
