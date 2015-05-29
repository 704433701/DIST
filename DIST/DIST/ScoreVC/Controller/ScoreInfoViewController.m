//
//  ScoreInfoViewController.m
//  DIST
//
//  Created by AngelLL on 15/5/26.
//  Copyright (c) 2015年 大连科技学院. All rights reserved.
//

#import "ScoreInfoViewController.h"
#import "ScoreInfoTableViewCell.h"


@interface ScoreInfoViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSArray *attArr;
@property (nonatomic, retain) NSArray *infoArr;

@end

@implementation ScoreInfoViewController

- (instancetype)initWithScore:(Score *)score
{
    self = [super init];
    if (self) {
        self.attArr = @[@"课程名称:", @"原始成绩:", @"转换成绩:", @"绩点:", @"学分:", @"任课老师:", @"考试类型:", @"状态:"];
        self.infoArr = @[score.courseName, score.YSscore, score.ZHscore, score.jd, score.credit, score.teacher, score.type, score.state];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[ScoreInfoTableViewCell class] forCellReuseIdentifier:@"scoreInfo"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScoreInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"scoreInfo"];
    cell.attributeLabel.text = [_attArr objectAtIndex:indexPath.row];
    cell.infoLabel.text = [_infoArr objectAtIndex:indexPath.row];
    cell.infoLabel.textColor = [UIColor blackColor];
    
    if (indexPath.row == 0) {
        cell.infoLabel.numberOfLines = 2;
    }
    if (indexPath.row == 1 && cell.infoLabel.text.integerValue < 60 && cell.infoLabel.text.integerValue > 0) {
        cell.infoLabel.textColor = [UIColor redColor];
    } else if (indexPath.row == 1) {
        cell.infoLabel.textColor = [UIColor greenSeaColor];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (HEIGHT - 0) / 8;
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
