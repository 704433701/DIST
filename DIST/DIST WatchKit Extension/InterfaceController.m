//
//  InterfaceController.m
//  DIST WatchKit Extension
//
//  Created by lanou3g on 15/5/14.
//  Copyright (c) 2015年 大连科技学院. All rights reserved.
//

#import "InterfaceController.h"
#import "RowController.h"
#import "DataBaseHandler.h"
#import "ClassTable.h"


@interface InterfaceController()
@property (strong, nonatomic) IBOutlet WKInterfaceTable *tableView;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *weekDayLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *weekLabel;

@property (nonatomic, retain) NSMutableArray *arr;
@property (nonatomic, assign) NSInteger weekDay;
@property (nonatomic, assign) NSInteger week; // 第几周
@property (nonatomic, strong) NSUserDefaults *sharedDefaults;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    // Configure interface objects here.
    
    DataBaseHandler *db = [DataBaseHandler shareInstance];
    [db opernDB];
    _sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.DIST.ClassTable"];
    _week = [_sharedDefaults integerForKey:@"week"] + 1;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:[NSDate date]];
    self.weekDay = theComponents.weekday;
    
    [self requestData];
    [self tableViewReloadData];
    
}

- (void)tableViewReloadData
{
    //清空列表
    NSRange range = NSMakeRange(0, [_tableView numberOfRows]);
    NSIndexSet*set = [NSIndexSet indexSetWithIndexesInRange:range];
    [_tableView removeRowsAtIndexes:set];
    
    for (NSInteger i = 0; i < _arr.count; i++) {
        [_tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:i] withRowType:@"RowController"];
        RowController *row = [self.tableView rowControllerAtIndex:i];
        ClassTable *classTable = [_arr objectAtIndex:i];
        NSString *str = [NSString stringWithFormat:@"%@\n%@", classTable.course,classTable.classroom];
        [row.label setText:str];
        NSInteger num = (classTable.number.integerValue / 7 + 1) * 2;
        [row.label2 setText:[NSString stringWithFormat:@"%ld\n%ld", num - 1, num]];
    }
    if (_arr.count <= 0) {
        [_tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:0] withRowType:@"RowController"];
        RowController *row = [self.tableView rowControllerAtIndex:0];
        [row.label setText:@"今天没课哦, 去看看新闻吧?"];
        [row.label2 setText:@"😄"];
    }
}


- (IBAction)leftAction {
    _weekDay = _weekDay - 1;
    if (_weekDay == 0) {
        _weekDay = 7;
    }
    [self requestData];
    [self tableViewReloadData];
}
- (IBAction)rightAction {
    _weekDay = (_weekDay) % 7 + 1;
    [self requestData];
    [self tableViewReloadData];
}

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex
{
    if (_arr.count > 0) {
        ClassTable *classTable = [_arr objectAtIndex:rowIndex];
        [self pushControllerWithName:@"ClassInfoController" context:classTable];
    }
}

#pragma mark - 查询数据库请求数据
- (void)requestData
{
    NSArray *weekArr = @[@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
    _weekDayLabel.text = [NSString stringWithFormat:@"     %@", [weekArr objectAtIndex:_weekDay - 1]];
    _weekLabel.text = [NSString stringWithFormat:@"第%ld周     ", _week];
    
    DataBaseHandler *db = [DataBaseHandler shareInstance];
    
    self.arr = [NSMutableArray array];
    NSArray *arrs = [db selectAllClass:_week];
    for (ClassTable *classtable in arrs) {
        NSInteger week = classtable.number.integerValue % 7;
        if (week == _weekDay - 2 || (_weekDay - 2 < 0 && week == 6)) {
            [_arr addObject:classtable];
        }
    }
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



