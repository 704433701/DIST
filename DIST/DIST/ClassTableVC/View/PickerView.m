//
//  PickerView.m
//  DIST
//
//  Created by lanou3g on 15/5/9.
//  Copyright (c) 2015年 大连科技学院. All rights reserved.
//

#import "PickerView.h"
#define BUTTON_HEIGHT 36

@implementation PickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - BUTTON_HEIGHT)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        
        _sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.DIST.ClassTable"];
        _newWeek = [_sharedDefaults integerForKey:@"week"];
        [_pickerView selectRow:_newWeek inComponent:0 animated:YES];
        [self addSubview:_pickerView];
        
        self.button = [UIButton buttonWithType:UIButtonTypeSystem];
        [_button setTitle:@"修改当前周" forState:UIControlStateNormal];
        _button.backgroundColor = [UIColor colorFromHexCode:@"#aa2116"];
        _button.layer.cornerRadius = 5;
        _button.tintColor = [UIColor whiteColor];
        _button.frame = CGRectMake(0, frame.size.height - BUTTON_HEIGHT, frame.size.width, BUTTON_HEIGHT);
        [self addSubview:_button];
    }
    return self;
}

- (NSInteger)newWeek
{
    return [_pickerView selectedRowInComponent:0];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 25;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *str = [NSString stringWithFormat:@"第%ld周", row + 1];
    return str;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _newWeek = row;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
