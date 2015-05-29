//
//  NewsListTableViewCell.h
//  DIST
//
//  Created by AngelLL on 15/5/27.
//  Copyright (c) 2015年 大连科技学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsInfo.h"

@interface NewsListTableViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) UILabel *monthLabel;
@property (nonatomic, retain) UILabel *dayLabel;

@property (nonatomic, retain) NewsInfo *info;
@end
