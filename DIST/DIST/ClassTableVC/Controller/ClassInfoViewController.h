//
//  ClassInfoViewController.h
//  DIST
//
//  Created by AngelLL on 15/5/27.
//  Copyright (c) 2015年 大连科技学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassTable.h"

@interface ClassInfoViewController : UIViewController

@property (nonatomic, assign) CGRect viewFrame;

- (id)initWithClassInfo:(ClassTable *)classInfo;
@end
