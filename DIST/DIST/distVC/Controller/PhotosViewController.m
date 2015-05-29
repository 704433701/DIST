//
//  PhotosViewController.m
//  DIST
//
//  Created by zhangjianhua on 15/4/17.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "PhotosViewController.h"
#import "SchoolBigCollectionViewCell.h"

@interface PhotosViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, retain) UILabel *pageLabel;
@end

@implementation PhotosViewController


- (instancetype)initWithArray:(NSMutableArray *)array
{
    self = [super init];
    if (self) {
        self.arr = [NSMutableArray arrayWithArray:array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(WIDTH, HEIGHT - 64);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.contentOffset = CGPointMake(WIDTH * self.top, 0);
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[SchoolBigCollectionViewCell class] forCellWithReuseIdentifier:@"cul"];
    
    self.pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, HEIGHT - 120, WIDTH, 50)];
    _pageLabel.textColor = [UIColor whiteColor];
    _pageLabel.textAlignment = NSTextAlignmentCenter;
    _pageLabel.text = [NSString stringWithFormat:@"%ld / %ld", _top + 1, _arr.count];
    [self.view addSubview:_pageLabel];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.arr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SchoolBigCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cul" forIndexPath:indexPath];
    cell.school = [self.arr objectAtIndex:indexPath.row];

    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _pageLabel.text = [NSString stringWithFormat:@"%.f / %ld", scrollView.contentOffset.x / WIDTH + 1, _arr.count];
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
