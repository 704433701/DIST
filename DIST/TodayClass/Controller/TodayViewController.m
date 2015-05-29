//
//  TodayViewController.m
//  TodayClass
//
//  Created by lanou3g on 15/5/8.
//  Copyright (c) 2015年 大连科技学院. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "DataBaseHandler.h"
#import "TodayTableViewCell.h"

#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height
#define HEADER_HEIGHT 44
#define CELL_HEIGHT 55

@interface TodayViewController () <NCWidgetProviding>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, retain) UILabel *weekDayLabel;
@property (nonatomic, retain) UILabel *weekLabel; // 第几周

@property (nonatomic, retain) NSMutableArray *arr;
@property (nonatomic, assign) NSInteger weekDay;
@property (nonatomic, assign) NSInteger week; // 第几周
@property (nonatomic, strong) NSUserDefaults *sharedDefaults;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DataBaseHandler *db = [DataBaseHandler shareInstance];
    [db opernDB];
    _sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.DIST.ClassTable"];
    _week = [_sharedDefaults integerForKey:@"week"] + 1;
    
    // Do any additional setup after loading the view from its nib.
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:[NSDate date]];
    self.weekDay = theComponents.weekday;
    NSLog(@"weekDay : %ld", _weekDay);
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    leftButton.frame = CGRectMake(5, 0, 30, HEADER_HEIGHT);
    [leftButton setBackgroundImage:[UIImage imageNamed:@"iconfont-left.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    self.weekDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, WIDTH / 3, HEADER_HEIGHT)];
    _weekDayLabel.font = [UIFont boldSystemFontOfSize:30.0f];
    _weekDayLabel.textColor = [UIColor whiteColor];
    _weekDayLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_weekDayLabel];
    
    self.weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 3 + 35, 10, WIDTH / 3, HEADER_HEIGHT - 10)];
    _weekLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_weekLabel];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(WIDTH - 35 - 50, 0, 30, HEADER_HEIGHT);
    [rightButton setBackgroundImage:[UIImage imageNamed:@"iconfont-arrow.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
    
    [self requestData];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, HEADER_HEIGHT, WIDTH, HEIGHT) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    
}

#pragma mark - 左右按钮方法
- (void)leftAction:(UIButton *)button
{
    _weekDay = _weekDay - 1;
    if (_weekDay == 0) {
        _weekDay = 7;
    }
    [self requestData];
    [_tableView reloadData];
}

- (void)rightAction:(UIButton *)button
{
    _weekDay = (_weekDay) % 7 + 1;
    [self requestData];
    [_tableView reloadData];
}

#pragma mark - 查询数据库请求数据
- (void)requestData
{
    NSArray *weekArr = @[@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
    _weekDayLabel.text = [weekArr objectAtIndex:_weekDay - 1];
    _weekLabel.text = [NSString stringWithFormat:@"第%ld周", _week];
    NSLog(@"weekDay : %ld", _weekDay);
    
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

#pragma mark - tableView 协议

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_arr.count <= 0) {
        self.preferredContentSize = CGSizeMake(0, CELL_HEIGHT + 44);
        return 1;
    }
    self.preferredContentSize = CGSizeMake(0, _arr.count * CELL_HEIGHT + 44);
    return _arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_arr.count <= 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.text = @"今天没课哦, 去看看新闻吧?";
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        cell.selectedBackgroundView = [[UIView alloc] init];
        return cell;
    }
    static NSString *CellIdentifier = @"Cell";
    TodayTableViewCell *cell = (TodayTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TodayTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.classTable = [_arr objectAtIndex:indexPath.row];
    CGRect rect = cell.frame;
    rect.size.height = CELL_HEIGHT;
    cell.frame = rect;
    cell.selectedBackgroundView = [[UIView alloc] init];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL *url = [NSURL URLWithString:@"ExtensionDIST://"];
    [self.extensionContext openURL:url completionHandler:^(BOOL success) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}



@end
