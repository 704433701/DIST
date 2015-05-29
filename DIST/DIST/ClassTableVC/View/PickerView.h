//
//  PickerView.h
//  DIST
//
//  Created by lanou3g on 15/5/9.
//  Copyright (c) 2015年 大连科技学院. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, retain) UIButton *button;
@property (nonatomic, retain) UIPickerView *pickerView;

@property (nonatomic, assign) NSInteger newWeek;

@property (nonatomic, strong) NSUserDefaults *sharedDefaults;

@end
