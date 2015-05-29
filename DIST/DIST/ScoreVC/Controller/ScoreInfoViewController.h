//
//  ScoreInfoViewController.h
//  DIST
//
//  Created by AngelLL on 15/5/26.
//  Copyright (c) 2015年 大连科技学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Score.h"

@interface ScoreInfoViewController : UIViewController

@property (nonatomic, retain) Score *score;

- (instancetype)initWithScore:(Score *)score;
@end
