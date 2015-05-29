//
//  ScoreViewController.m
//  DIST
//
//  Created by lanou3g on 15/5/13.
//  Copyright (c) 2015年 大连科技学院. All rights reserved.
//

#import "ScoreViewController.h"
#import "Score.h"
#import "ScoreTableViewCell.h"
#import "ScoreInfoViewController.h"

@interface ScoreViewController ()<UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) UIButton *button;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) UIView *changeView;

@property (nonatomic, retain) NSMutableArray *textArr;
@property (nonatomic, retain) NSArray *urlArr;
@property (nonatomic, assign) NSInteger term;
@property (nonatomic, retain) NSMutableArray *scoreArr;

@property (nonatomic, assign) NSInteger beginYear;
@end

@implementation ScoreViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.urlArr = @[@"17", @"20", @"25", @"29", @"33", @"35", @"39", @"40"];
        _term = 7;
        self.textArr = [NSMutableArray array];
        for (NSInteger i = 0; i < 4; i++) {
            for (NSInteger j = 0; j < 2; j++) {
                NSString *str = [NSString stringWithFormat:@"%ld-%ld学年 第%ld学期", i + 11, i + 12, j + 1];
                [_textArr addObject:str];
            }
        }
        NSString *userYear = [[[NSUserDefaults standardUserDefaults] objectForKey:@"user"] substringToIndex:2];
        for (NSInteger i = 0; i < _textArr.count; i++) {
            if ([userYear isEqualToString:[[_textArr objectAtIndex:i] substringToIndex:2]]) {
                _beginYear = i;
                NSLog(@"%ld", _beginYear);
                break;
            }
        }
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"教务成绩查询";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    [_button setTitle:@"14-15学年 第2学期" forState:UIControlStateNormal];
    _button.frame = CGRectMake(0, 0, WIDTH, 40);
    _button.backgroundColor = [UIColor colorFromHexCode:@"#aa2116"];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(changeTerm:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, WIDTH, HEIGHT - 64 - 40) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    __weak __typeof(self)weakSelf = self;
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf freshenAction];
    }];
    
    [_tableView registerClass:[ScoreTableViewCell class] forCellReuseIdentifier:@"score"];
    
    self.changeView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH / 6, - WIDTH * 2 / 3, WIDTH * 2 / 3, WIDTH * 2 / 3)];
    _changeView.backgroundColor = BACKGROUND_COLOR;
    _changeView.layer.cornerRadius = 5;
    [self.view addSubview:_changeView];
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, WIDTH * 2 / 3, WIDTH * 2 / 3)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [_pickerView selectRow:_term - _beginYear inComponent:0 animated:YES];
    [self.changeView addSubview:_pickerView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, _changeView.frame.size.height - 40, _changeView.frame.size.width, 40);
    [button addTarget:self action:@selector(yesAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"选  择" forState:UIControlStateNormal];
    button.layer.cornerRadius = 5;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorFromHexCode:@"#aa2116"];
    [self.changeView addSubview:button];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_scoreArr) {
        [self freshenAction];
    }
}

#pragma mark - 修改当前学期按钮事件
- (void)changeTerm:(UIButton *)button
{
    [UIView animateWithDuration:0.7 animations:^{
        _changeView.frame = CGRectMake(WIDTH / 6, 0, WIDTH * 2 / 3, WIDTH * 2 / 3);
    }];
}

- (void)yesAction:(UIButton *)button
{
    [UIView animateWithDuration:0.7 animations:^{
        _changeView.frame = CGRectMake(WIDTH / 6, - WIDTH * 2 / 3, WIDTH * 2 / 3, WIDTH * 2 / 3);
    }];
    _term = [_pickerView selectedRowInComponent:0] + _beginYear;
    [_button setTitle:[_textArr objectAtIndex:_term] forState:UIControlStateNormal];
    [self freshenAction];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.7 animations:^{
        _changeView.frame = CGRectMake(WIDTH / 6, - WIDTH * 2 / 3, WIDTH * 2 / 3, WIDTH * 2 / 3);
    }];
}

#pragma mark - pickerView 协议
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _textArr.count - _beginYear;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  
    return [_textArr objectAtIndex:row + _beginYear];
}


#pragma mark - tableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _scoreArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"score"];
    cell.score = [_scoreArr objectAtIndex:indexPath.row];
    cell.frame = CGRectMake(0, 0, WIDTH, 60);
    if (indexPath.row % 2) {
        cell.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Score *score = [_scoreArr objectAtIndex:indexPath.row];
    ScoreInfoViewController *infoVC = [[ScoreInfoViewController alloc] initWithScore:score];
    infoVC.score = score;
    [self.navigationController pushViewController:infoVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - 请求网络数据
- (void)freshenAction
{
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"];
    if (user.length > 0 && pwd.length > 0) {
        [self requestDataWithUser:user password:pwd];
    }
}
- (void)requestDataWithUser:(NSString *)user password:(NSString *)pwd
{
    MBProgressHUD *mb = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:mb];
    mb.mode = MBProgressHUDModeIndeterminate;
    [mb show:YES];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSDictionary *dict = @{ @"username":user, @"password":pwd, @"mynum":@"1"};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:@"http://125.222.144.19/userlog.asp" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([operation.response.URL isEqual:[NSURL URLWithString:@"http://125.222.144.19/student/index.asp"]]) {
            NSString *urlStr = [@"http://125.222.144.19/student/report.asp?tmid=" stringByAppendingString:[_urlArr objectAtIndex:_term]];
            [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                TFHpple *xpathParser = [[TFHpple alloc]initWithHTMLData:responseObject];
                NSArray *contentArray = [xpathParser searchWithXPathQuery:@"//font[@size=\"2\"]"];

                NSMutableArray *strArr = [NSMutableArray array];
                for (NSInteger i = 11; i < contentArray.count; i++) {
                    TFHppleElement *element = [contentArray objectAtIndex:i];
                  
                    NSString *str = [element content];
                    
                    if (str.length == 0) {
                        str = [[[element children] lastObject] content];
                    }
                    
                    str = [str stringByReplacingOccurrencesOfString:@"&nbsp" withString:@""];
                    [strArr addObject:str];
                }
                
                self.scoreArr = [NSMutableArray array];
                for (NSInteger i = 0; i < strArr.count / 11; i++) {
                    Score *score = [[Score alloc] init];
                    
                    NSString *str = [strArr objectAtIndex:i * 11];
                    NSString *regEx = @"\\d+";
                    NSError *error = NULL;
                    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regEx options:NSRegularExpressionCaseInsensitive error:&error];
                    NSTextCheckingResult *res = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
                    score.courseName = [str substringFromIndex:res.range.length];
                    score.number = [str substringWithRange:res.range];
                    score.credit = [strArr objectAtIndex:i * 11 + 1];
                    score.YSscore = [strArr objectAtIndex:i * 11 + 2];
                    score.ZHscore = [strArr objectAtIndex:i * 11 + 3];
                    score.jd = [strArr objectAtIndex:i * 11 + 4];
                    score.teacher = [strArr objectAtIndex:i * 11 + 7];
                    score.type = [strArr objectAtIndex:i * 11 + 8];
                    score.state = [strArr objectAtIndex:i * 11 + 9];
                    [_scoreArr addObject:score];
                }
                [_tableView reloadData];
                [_tableView.header endRefreshing];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [_tableView.header endRefreshing];
            }];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器出错, 请稍后重试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"返回", nil];
            [alert show];
            [_tableView.header endRefreshing];
        }
        [mb hide:YES];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [mb hide:YES afterDelay:1];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络错误, 请检查网络后重试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"返回", nil];
        [alert show];
        [_tableView.header endRefreshing];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
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
