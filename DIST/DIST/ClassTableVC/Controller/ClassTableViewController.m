//
//  ClassTableViewController.m
//  DIST
//
//  Created by 张健华 on 15/4/17.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "ClassTableViewController.h"
#import "WeekCollectionViewCell.h"
#import "HeaderCollectionViewCell.h"
#import "ClassInfoViewController.h"

#import "ClassTable.h"
#import "PickerView.h"

#define WeekWIDTH (self.view.frame.size.width - _timeTableViewWIDTH) / 6

typedef enum : NSUInteger {
    Monday = 2,//    星期一
    Tuesday,//    星期二
    Wednesday,//   星期三
    Thursday,//   星期四
    Friday,//   星期五
    Saturday,//   星期六
    Sunday = 7,//   星期日
} weekDay;

@interface ClassTableViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) LoginViewController *addClassVC;
@property (nonatomic, retain) PickerView *weekView;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UICollectionView *collectionView; // 课程
@property (nonatomic, retain) UITableView *tableView; // 时间

// title View
@property (nonatomic, retain) UIButton *button;
@property (nonatomic, retain) UILabel *label;

@property (nonatomic, assign) BOOL weekFlag;
@property (nonatomic, assign) NSInteger weekDay;
@property (nonatomic, assign) NSInteger week; // 第几周

@property (nonatomic, assign) NSInteger timeTableViewWIDTH;
@property (nonatomic, retain) NSMutableArray *arr;

@property (nonatomic, strong) NSUserDefaults *sharedDefaults;
@end

@implementation ClassTableViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.DIST.ClassTable"];
        _week = [_sharedDefaults integerForKey:@"week"] + 1;
//        NSString *timeStr = @"2015/06/11 10:42:28";
//        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
//        [formatter2 setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
//        NSDate *strDate = [formatter2 dateFromString:timeStr];
        
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:[_sharedDefaults objectForKey:@"firstWeek"]];
        NSInteger intervalWeek = interval / ( 24 * 60 * 60 * 7);
        if (intervalWeek >= 1) {
            _week = _week + intervalWeek;
            [_sharedDefaults setInteger:_week - 1 forKey:@"week"];
        }
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    将NSArray转化为NSData类型 ：NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
//    将NSData转化为NSArray类型 ：NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    // 屏幕适配
    
    NSInteger width = [[UIScreen mainScreen] bounds].size.width;
    if (width == 375) {
        _timeTableViewWIDTH = 45;
    } else if (width == 320) {
        _timeTableViewWIDTH = 44;
    } else if (width == 414) {
        _timeTableViewWIDTH = 45;
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64)];
    imageView.image = [UIImage imageNamed:@"u=3350805932,1762210393&fm=21&gp=0"];
    [self.view addSubview:imageView];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:[NSDate date]];
    self.weekDay = theComponents.weekday;
    
    // title
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH / 5 + 5, 44)];
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    _button.frame = CGRectMake(0, 0, WIDTH / 5 + 5, 44);
    [_button setImage:[UIImage imageNamed:@"iconfont-xiangxia"] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(weakAction:) forControlEvents:UIControlEventTouchUpInside];
    [_button setImageEdgeInsets:UIEdgeInsetsMake(10, WIDTH / 5 - 20 + 5, 10, 0)];
    [view addSubview:_button];
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH / 5, 44)];
    _label.text = [NSString stringWithFormat:@"第%ld周",_week];
    _label.textColor = [UIColor whiteColor];
    [view addSubview:_label];
    self.navigationItem.titleView = view;
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addClassTable:)];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(_timeTableViewWIDTH, 0, WIDTH - _timeTableViewWIDTH, HEIGHT - 64)];
    _scrollView.contentSize = CGSizeMake(WeekWIDTH * 8, 0);
    if (_weekDay > 5 || _weekDay < 2) {
        _scrollView.contentOffset = CGPointMake(WeekWIDTH * 2, 0);
    }
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WeekWIDTH * 8, HEIGHT - 64) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.scrollView addSubview:_collectionView];
    
    [_collectionView registerClass:[WeekCollectionViewCell class] forCellWithReuseIdentifier:@"class"];
    [_collectionView registerClass:[HeaderCollectionViewCell class] forCellWithReuseIdentifier:@"header"];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _timeTableViewWIDTH, HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.backgroundColor = ClassTable_borderColor;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
  //  _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestCoreData];
}

- (void)requestCoreData
{
    NSString *tokeStr;
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"\\<\\>"];
    tokeStr = [tokeStr stringByTrimmingCharactersInSet:set];
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    self.context = app.managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ClassTable"];
    // 谓言
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"beginWeek <= %ld and endWeek >= %ld or beginWeek = 0", _week, _week];
    request.predicate = predicate;
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"number" ascending:YES];
    request.sortDescriptors = @[sort];
    NSArray *classArr = [self.context executeFetchRequest:request error:nil];
    
    self.arr = [NSMutableArray arrayWithArray:classArr];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (ClassTable *class in classArr) {
        [arr addObject:class.number];
    }
    for (NSInteger i = 0; i < 49; i++) {
        if (![arr containsObject:@(i)]) {
            ClassTable *class = [NSEntityDescription insertNewObjectForEntityForName:@"ClassTable" inManagedObjectContext:self.context];
            class.number = @(i);
            [_arr insertObject:class atIndex:i];
            [self.context deleteObject:class];
        }
    }
    while ([[[_arr lastObject] beginWeek] isEqualToNumber:@(0)]) {
        [_arr removeObject:[_arr lastObject]];
    }
    if (_arr.count == 0 && [[NSUserDefaults standardUserDefaults] objectForKey:@"user"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"恭喜你" message:@"本周没课哦!\n快去看看书或者逛逛海边吧!" delegate:self cancelButtonTitle:@"换一周" otherButtonTitles:@"好的~", nil];
        [alert show];
    }
    
    [self calibration];
    
    [self.collectionView reloadData];
    [self.tableView reloadData];
}

#pragma mark - UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self weakAction:_button];
            break;
            
        default:
            [self.navigationController popViewControllerAnimated:YES];
            break;
    }
}

#pragma mark - 添加课表方法
- (void)addClassTable:(UIBarButtonItem *)barButton
{
    self.addClassVC = [[LoginViewController alloc] init];
    BaseNavigationController *navi = [[BaseNavigationController alloc] initWithRootViewController:_addClassVC];
    _addClassVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-xiangxia (1).png"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    [self presentViewController:navi animated:YES completion:^{
        _addClassVC.context = self.context;
    }];
}
- (void)backAction:(UIBarButtonItem *)barButton
{
    [_addClassVC dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - title开关
- (void)weakAction:(UIButton *)button
{
    if (_weekFlag) {
        [button setImage:[UIImage imageNamed:@"iconfont-xiangxia.png"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5 animations:^{
            _weekView.frame = CGRectMake(WIDTH / 3, - 200, WIDTH / 3, 200);
        } completion:^(BOOL finished) {
            [_weekView removeFromSuperview];
        }];
    } else {
        [button setImage:[UIImage imageNamed:@"iconfont-xiangshang.png"] forState:UIControlStateNormal];
        self.weekView = [[PickerView alloc] initWithFrame:CGRectMake(WIDTH / 3, - 200, WIDTH / 3, 200)];
        [_weekView.button addTarget:self action:@selector(changeNewWeek:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_weekView];
        [UIView animateWithDuration:0.5 animations:^{
            _weekView.frame = CGRectMake(WIDTH / 3, 5, WIDTH / 3, 200);
        }];
    }
    _weekFlag = !_weekFlag;
}

- (void)changeNewWeek:(UIButton *)button
{
    _week = _weekView.newWeek + 1;
    _label.text = [NSString stringWithFormat:@"第%ld周", _week];
    
    [_sharedDefaults setInteger:_weekView.newWeek forKey:@"week"];
    [_sharedDefaults synchronize];
    [self weakAction:_button];
    [self requestCoreData];
}

- (void)calibration
{
    NSDate *firstWeek = [NSDate dateWithTimeIntervalSinceNow: - 24 * 60 * 60 * (_weekDay - 2)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSString *localDateStr = [formatter stringFromDate:firstWeek];
    localDateStr = [localDateStr stringByAppendingString:@" 00:00:00"];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    firstWeek = [formatter dateFromString:localDateStr];
    [_sharedDefaults setObject:firstWeek forKey:@"firstWeek"];
}

#pragma mark - collectionView协议
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 7;
    }
    return _arr.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"header" forIndexPath:indexPath];
        cell.view.hidden = YES;
        cell.contentView.backgroundColor = ClassTable_borderColor;
        NSArray *weekArr = @[@"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日"];
        cell.label.text = [weekArr objectAtIndex:indexPath.item];
        NSInteger week = indexPath.item % 7;
        if (week == _weekDay - 2 || (_weekDay - 2 < 0 && week == 6)) {
            cell.view.hidden = NO;
        }
        return cell;
    } else {
        WeekCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"class" forIndexPath:indexPath];
        cell.label.text = nil;
        cell.label.textColor = [UIColor whiteColor];
        cell.imageView.hidden = YES;
        ClassTable *classtable = [_arr objectAtIndex:indexPath.item];
        if (classtable.beginWeek.integerValue != 0) {
            NSString *str = [NSString stringWithFormat:@"%@\n%@", classtable.course, classtable.classroom];
            cell.label.text = str;
            cell.imageView.hidden = NO;
        }
    return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSInteger week = indexPath.item % 7;
        if (week == _weekDay - 2 || (_weekDay - 2 < 0 && week == 6)) {
            return CGSizeMake(WeekWIDTH * 2, 44);
        } else {
            return CGSizeMake(WeekWIDTH, 44);
        }
    } else {
        NSInteger week = indexPath.item % 7;
        if (week == _weekDay - 2 || (_weekDay - 2 < 0 && week == 6)) {
            return CGSizeMake(WeekWIDTH * 2, 88);
        } else {
            return CGSizeMake(WeekWIDTH, 88);
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.item < 6) {
                self.weekDay = indexPath.item + 2;
            } else {
                self.weekDay = 1;
            }
            [self.collectionView reloadData];
            break;
        }

        default:
        {
            ClassTable *classtable = [_arr objectAtIndex:indexPath.item];
            if (classtable.beginWeek.integerValue != 0) {
                ClassInfoViewController *infoVC = [[ClassInfoViewController alloc] initWithClassInfo:classtable];
                WeekCollectionViewCell *cell = (WeekCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
                infoVC.viewFrame = CGRectMake(cell.frame.origin.x + _timeTableViewWIDTH, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
                [self addChildViewController:infoVC];
                [self.view addSubview:infoVC.view];
            }
            break;
        }
    }
}

#pragma mark - tableView协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_arr.count == 0) {
        return 0;
    }
    return _arr.count / 7 * 2 + 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"time"];
    if (indexPath.row != 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _tableView.contentOffset = CGPointMake(0, _collectionView.contentOffset.y);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
