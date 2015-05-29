//
//  NewsViewController.m
//  DIST
//
//  Created by zhangjianhua on 15/4/13.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsInfo.h"
#import "NewsInfoViewController.h"
#import "NewsListTableViewCell.h"

@interface NewsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *arr;
@property (nonatomic, retain) NSMutableArray *timeArr;
@property (nonatomic, retain) NSMutableArray *indexPaths;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger count;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.arr = [NSMutableArray array];
    self.timeArr = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    self.page = 1;
    
    __weak __typeof(&*self)blockSelf = self;
    [_tableView addLegendFooterWithRefreshingBlock:^{
        [blockSelf requestDataWithPage:blockSelf.page];
    }];
    [_tableView.footer beginRefreshing];
 //   [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"newsCell"];
}

- (void)requestDataWithPage:(NSInteger)page
{
    NSString *urlStr = [NSString stringWithFormat:@"http://www.ieidjtu.edu.cn/channel.asp?id=%@&page=%ld", self.listID, page];
    NSInteger number = _arr.count;
    self.indexPaths = [NSMutableArray array];
    [NetHandler getDataWithUrl:urlStr completion:^(NSData *data) {
        
        TFHpple *xpathParser = [[TFHpple alloc]initWithHTMLData:data];
        NSArray *contentArray = [xpathParser searchWithXPathQuery:@"//a"];
        NSArray *timeArray = [xpathParser searchWithXPathQuery:@"//span"];
        NSArray *labelArray = [xpathParser searchWithXPathQuery:@"//label"];
        
        if (contentArray.count != 0 && timeArray.count != 0 && labelArray.count != 0) {
            for (NSInteger i = 0; i < timeArray.count - 1; i++) {
                NewsInfo *news = [[NewsInfo alloc] init];
                TFHppleElement *aElement = [contentArray objectAtIndex:i + 59];
                NSString *title = [aElement content];
                news.title = title;
                
                TFHppleElement *count = [labelArray objectAtIndex:0];
                self.count = [[count content] integerValue];
                
                TFHppleElement *date = [timeArray objectAtIndex:i];
                news.date = [date content];
                
                NSDictionary *dic = [aElement attributes];
                news.ID = [dic objectForKey:@"href"];
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:number + i inSection:0];
                [self.arr addObject:news];
                [_indexPaths addObject: indexPath];
            }
        }
        if (self.arr.count >= self.count) {
            NSLog(@"%ld", self.arr.count);
            [_tableView.footer noticeNoMoreData];
        } else {
            _page = self.arr.count / 18 + 1;
            [_tableView.footer endRefreshing];
        }
      ////  [self.tableView beginUpdates];
        if (number < _arr.count) {
            
        [self.tableView insertRowsAtIndexPaths:_indexPaths withRowAnimation:UITableViewRowAnimationBottom];
        }
       // [self.tableView endUpdates];
       // [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell"];
    if (cell == nil) {
        cell = [[NewsListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"newsCell"];
    }
    NewsInfo *new = [self.arr objectAtIndex:indexPath.row];
    cell.info = new;
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"cell_%ld", indexPath.row % 2]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewsInfoViewController *infoVC = [[NewsInfoViewController alloc] init];
    infoVC.news = [self.arr objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:infoVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark - cell动画
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CATransform3D rotation;
   // rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation = CATransform3DMakeScale(1.2, 1.2, 1.2);
    rotation.m34 = 1.0/ -600;
    
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    cell.layer.transform = rotation;
    //cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
    
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
