//
//  ScoreListViewController.m
//  DIST
//
//  Created by AngelLL on 15/5/29.
//  Copyright (c) 2015年 大连科技学院. All rights reserved.
//

#import "ScoreListViewController.h"
#import "ScoreViewController.h"
#import "ScoreWebViewController.h"


@interface ScoreListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSArray *arr;
@property (nonatomic, retain) NSArray *urlArr;

@end

@implementation ScoreListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.arr = @[@"教务成绩查询", @"英语四六级", @"普通话水平测试", @"全国计算机等级考试"];
        self.urlArr = @[@"http://score.super.cn/Score/cet.html", @"http://score.super.cn/Score/chinese.html", @"http://score.super.cn/Score/computer.html"];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"成绩查询";
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor colorWithRed: 216.0 / 255.0  green:242.0 / 255.0 blue:255.0 / 255.0 alpha:1];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"scoreList"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"scoreList"];
    
    cell.textLabel.text = [_arr objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"选择你要查询的成绩";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            ScoreViewController *scoreVC = [[ScoreViewController alloc] init];
            [self.navigationController pushViewController:scoreVC animated:YES];
            break;
        }
        default:
        {
            ScoreWebViewController *webVC = [[ScoreWebViewController alloc] init];
            webVC.title = [_arr objectAtIndex:indexPath.row];
            webVC.urlStr = [_urlArr objectAtIndex:indexPath.row - 1];
            [self.navigationController pushViewController:webVC animated:YES];
            break;
        }
    }
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
