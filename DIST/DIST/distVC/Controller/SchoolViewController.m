//
//  SchoolViewController.m
//  DIST
//
//  Created by zhangjianhua on 15/4/16.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "SchoolViewController.h"
#import "NewsInfo.h"
#import "SchoolCollectionViewCell.h"
#import "PhotosViewController.h"

@interface SchoolViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, retain) NSMutableArray *arr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) BOOL loadEnd;

@end

@implementation SchoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.arr = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(WIDTH / 2 - 20, HEIGHT / 6);
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 5.0 / 2.0;
    flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 10, 15);

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64)collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    self.page = 1;
    
    __weak __typeof(&*self)blockSelf = self;
    [_collectionView addLegendFooterWithRefreshingBlock:^{
        [blockSelf requestDataWithPage:blockSelf.page];
    }];
    [_collectionView registerClass:[SchoolCollectionViewCell class] forCellWithReuseIdentifier:@"school"];
    [_collectionView.footer beginRefreshing];
}

- (void)requestDataWithPage:(NSInteger)page
{
    NSString *urlStr = [NSString stringWithFormat:@"http://www.ieidjtu.edu.cn/channel.asp?id=%@&page=%ld", self.listID, page];
    [NetHandler getDataWithUrl:urlStr completion:^(NSData *data) {

        NSString *htmlStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSString *regEx = @"<img[^>]+src=['\"](.*?)['\"][^>]*>";
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regEx options:NSRegularExpressionCaseInsensitive error:&error];
        NSArray *arr = [regex matchesInString:htmlStr options:0 range:NSMakeRange(0, [htmlStr length])];
        for (NSTextCheckingResult *result in arr) {
            NSString *img = [htmlStr substringWithRange:result.range];
            NewsInfo *school = [[NewsInfo alloc] init];
            
            NSString *regEx = @"src=['\"](.*?)['\"]";
            NSError *error = NULL;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regEx options:NSRegularExpressionCaseInsensitive error:&error];
            NSTextCheckingResult *res = [regex firstMatchInString:img options:0 range:NSMakeRange(0, [img length])];
            
            school.ID = [NSString stringWithFormat:@"http://www.ieidjtu.edu.cn/%@", [img substringWithRange:NSMakeRange(res.range.location + 5, res.range.length - 6)]];
            
            NSString *regEx1 = @"title=['\"](.*?)['\"]";
            NSError *error1 = NULL;
            NSRegularExpression *regex1 = [NSRegularExpression regularExpressionWithPattern:regEx1 options:NSRegularExpressionCaseInsensitive error:&error1];
            NSTextCheckingResult *res1 = [regex1 firstMatchInString:img options:0 range:NSMakeRange(0, [img length])];
            
            school.title = [img substringWithRange:NSMakeRange(res1.range.location + 7, res1.range.length - 8)];
            [self.arr addObject:school];
            
        }
        if (self.arr.count - (_page - 1) * 9 < 9) {
            [_collectionView.footer noticeNoMoreData];
        } else {
            _page = self.arr.count / 9 + 1;
            [_collectionView.footer endRefreshing];
            _loadEnd = YES;
        }
        [self.collectionView reloadData];
    }];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (_arr.count % 2 == 0 || _loadEnd) {
        return self.arr.count;
    } else {
        return self.arr.count - 1;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SchoolCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"school" forIndexPath:indexPath];
    cell.school = [self.arr objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"a");
    PhotosViewController *photoVC = [[PhotosViewController alloc] initWithArray:self.arr];
    photoVC.top = indexPath.item;
    [self.navigationController pushViewController:photoVC animated:YES];
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
