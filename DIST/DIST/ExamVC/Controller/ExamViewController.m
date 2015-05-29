//
//  ExamViewController.m
//  DIST
//
//  Created by lanou3g on 15/5/11.
//  Copyright (c) 2015年 大连科技学院. All rights reserved.
//

#import "ExamViewController.h"
#import "ExamInfo.h"
#import "ExamInfoViewController.h"
#import "ExamTableViewCell.h"

@interface ExamViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UISearchBar *searchBar; // 搜索
@property (nonatomic, retain) UISegmentedControl *seg; // 排序
@property (nonatomic, retain) NSMutableArray *arr;
@property (nonatomic, retain) NSMutableArray *releaseArr;
@property (nonatomic, retain) NSMutableArray *examArr;
@property (nonatomic, retain) NSUserDefaults *user;
@end

@implementation ExamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"考试查询";
    self.view.backgroundColor = [UIColor whiteColor];
    _user = [NSUserDefaults standardUserDefaults];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 35)];
    // 搜索栏半透明
    self.searchBar.translucent = YES;
    // 代理
    self.searchBar.delegate = self;
    _searchBar.placeholder = @"按课程名关键字搜索";
    //    有一个按键
//        self.searchBar.showsCancelButton = YES;
    
    //    取消调用的键盘
    //    [self.searchBar resignFirstResponder];
    
    //    把tableView添加到搜索栏
    //    self.tableView.tableHeaderView = self.searchBar;
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:_searchBar];
    
    self.seg = [[UISegmentedControl alloc] initWithItems:@[@"发布时间 △", @"发布时间 ▽", @"考试时间 △", @"考试时间 ▽"]];
    _seg.tintColor = [UIColor colorFromHexCode:@"#aa2116"];
    _seg.frame = CGRectMake(10, 35, WIDTH - 20, 30);
    _seg.selectedSegmentIndex = 0;
    [self.seg addTarget:self action:@selector(changeAction:) forControlEvents: UIControlEventValueChanged];
    [self.view addSubview:_seg];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, WIDTH, HEIGHT - 64 - 65) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    __weak __typeof(self)weakSelf = self;
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf freshenAction];
    }];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, ((HEIGHT - 108) - WIDTH) / 2, WIDTH, WIDTH)];
    _imageView.image = [UIImage imageNamed:@"tishi"];
    [self.view addSubview:_imageView];
    _imageView.hidden = YES;

}

- (void)freshenAction
{
    NSString *user = [_user objectForKey:@"user"];
    NSString *pwd = [_user objectForKey:@"pwd"];
    if (user.length > 0 && pwd.length > 0) {
        [self requestDataWithUser:user password:pwd];
    }
}

//点击搜索框上的 取消按钮时调用
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    // 收回取消按钮
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    // 结束编辑 (回收键盘)
    [self.view endEditing:YES];
}

//点击搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSMutableArray *searchArr = [NSMutableArray array];
    for (ExamInfo *info in _releaseArr) {
        
        NSRange range = [[info.title uppercaseString] rangeOfString:[searchBar.text uppercaseString]];//匹配得到的下标
        if (range.length != 0) {
            [searchArr addObject:info];
        }
    }
    _imageView.hidden = YES;
    if (searchArr.count == 0) {
        _imageView.hidden = NO;
    }
    _arr = [NSMutableArray arrayWithArray:searchArr];
    [_tableView reloadData];
    // 收回取消按钮重修
    self.searchBar.showsCancelButton = NO;
    // 结束编辑 (回收键盘)
    [self.view endEditing:YES];
}


// 搜索栏已经开始编辑 (修改searchBar的隐藏按钮的title)
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    // 先遍历searchBar 搜索到View
    for(id cc in [searchBar subviews])
    {
        // 再遍历View搜索到button
        for (id a in [cc subviews])
        {
            // 判断
            if([a isKindOfClass:[UIButton class]])
            {
                UIButton *btn = a;
                btn.tintColor = [UIColor colorFromHexCode:@"#aa2116"];
                [btn setTitle:@"取消"  forState:UIControlStateNormal];
            }
        }
    }
}


//搜索内容改变
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}

- (void)changeAction:(UISegmentedControl *)seg
{
    _imageView.hidden = YES;
    if (seg.selectedSegmentIndex == 0) {
        self.arr = [NSMutableArray arrayWithArray:_releaseArr];
    } else if (seg.selectedSegmentIndex == 1) {
        self.arr = [NSMutableArray arrayWithArray:[[_releaseArr reverseObjectEnumerator] allObjects]];
    } else if (seg.selectedSegmentIndex == 2) {
        for (NSInteger i = 0; i < _examArr.count - 1; i++) {
            for (NSInteger j = 0; j < _examArr.count - 1 - i; j++) {
                ExamInfo *front = [_examArr objectAtIndex:j];
                ExamInfo *after = [_examArr objectAtIndex:j + 1];
                if (front.time.integerValue > after.time.integerValue) {
                    [_examArr exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                }
            }
        }
        self.arr = [NSMutableArray arrayWithArray:_examArr];
    } else if (seg.selectedSegmentIndex == 3) {
        for (NSInteger i = 0; i < _examArr.count - 1; i++) {
            for (NSInteger j = 0; j < _examArr.count - 1 - i; j++) {
                ExamInfo *front = [_examArr objectAtIndex:j];
                ExamInfo *after = [_examArr objectAtIndex:j + 1];
                if (front.time.integerValue < after.time.integerValue) {
                    [_examArr exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                }
            }
        }
        self.arr = [NSMutableArray arrayWithArray:_examArr];
    }
    [_tableView reloadData];
    [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
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
            self.releaseArr = [NSMutableArray array];
            TFHpple *xpathParser = [[TFHpple alloc]initWithHTMLData:responseObject];
            NSArray *contentArray = [xpathParser searchWithXPathQuery:@"//b"];
            NSArray *urlArr = [xpathParser searchWithXPathQuery:@"//a"];
            
            
            // title
            for (NSInteger i = 0; i < contentArray.count / 2; i++) {
                TFHppleElement *aElementTitle = [contentArray objectAtIndex:i * 2];
                NSString *title = [aElementTitle content];
                if ([title hasPrefix:@"大连科技学院教务处官网"]) {
                    break;
                }
                TFHppleElement *aElementTime = [contentArray objectAtIndex:i * 2 + 1];
                NSString *time = [aElementTime content];
                ExamInfo *exam = [[ExamInfo alloc] init];
                exam.title = title;
                exam.time = time;
                [_releaseArr addObject:exam];
            }
            
            for (NSInteger i = 0; i < _releaseArr.count; i++) {
                TFHppleElement *aElement = [urlArr objectAtIndex:i];
                NSDictionary *dic = [aElement attributes];
                NSString *url = [dic objectForKey:@"onclick"];
                if ([url hasPrefix:@"window.open('"]) {
                    url = [url substringWithRange:NSMakeRange(13, url.length - 42)];
                    [[_releaseArr objectAtIndex:i] setInfoUrl:url];
                }
            }
            _arr = [NSMutableArray arrayWithArray:_releaseArr];
            _examArr = _arr;
            _imageView.hidden = YES;
            if (_releaseArr.count <= 0) {
                _imageView.hidden = NO;
            }
            [self.tableView reloadData];
            _seg.selectedSegmentIndex = 0;
            [_tableView.header endRefreshing];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器出错, 请稍后重试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
            [alert show];
            [_tableView.header endRefreshing];
        }
        [mb hide:YES];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [mb hide:YES afterDelay:1];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络错误, 请检查网络后重试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alert show];
        [_tableView.header endRefreshing];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"exam"];
    if (cell == nil) {
        cell = [[ExamTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"exam"];
    }
    cell.info = [_arr objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExamInfoViewController *infoVC = [[ExamInfoViewController alloc] init];
    infoVC.info = [_arr objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:infoVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_arr) {
        [self freshenAction];
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
