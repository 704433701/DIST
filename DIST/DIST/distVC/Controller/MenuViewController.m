//
//  NewsViewController.m
//  DIST
//
//  Created by zhangjianhua on 15/4/11.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "MenuViewController.h"
#import "NewsViewController.h"
#import "SchoolViewController.h"
#import "MenuCollectionViewCell.h"

@interface MenuViewController () <UICollectionViewDataSource, UICollectionViewDelegate, RESideMenuDelegate>

@property (nonatomic, retain) UICollectionView *collectionView;

@property (nonatomic, retain) NSArray *labelArr;

@end

@implementation MenuViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.labelArr = @[@"校园新闻", @"信息公告", @"学生活动", @"校园文化", @"校园风光", @"课程表", @"考试查询", @"成绩查询", @"更多"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"user"] style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64)];
    bgImageView.image = [UIImage imageNamed:@"distBg.png"];
    [self.view addSubview:bgImageView];
    
    CGFloat titleH = HEIGHT / 5;
    UIImageView *titleBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, titleH / 4, WIDTH, titleH / 2)];
    titleBg.image = [UIImage imageNamed:@"title"];
    [self.view addSubview:titleBg];

    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(WIDTH / 3 - 20, WIDTH / 3 - 20);
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, HEIGHT / 5, WIDTH, HEIGHT * 4 / 5 - 64) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[MenuCollectionViewCell class] forCellWithReuseIdentifier:@"menu"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _labelArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"menu" forIndexPath:indexPath];
    cell.label.text = [_labelArr objectAtIndex:indexPath.item];
    NSString *imageName = [NSString stringWithFormat:@"%ld.png", indexPath.item];
    cell.imageView.image = [UIImage imageNamed:imageName];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.item) {
        case 0:
        {
            NewsViewController *newsVC = [[NewsViewController alloc] init];
            newsVC.title = @"学院新闻";
            newsVC.listID = @"98";
            [self.navigationController pushViewController:newsVC animated:YES];
           break;
        }
        case 1:
        {
            NewsViewController *newsVC = [[NewsViewController alloc] init];
            newsVC.title = @"信息公告";
            newsVC.listID = @"99";
            [self.navigationController pushViewController:newsVC animated:YES];
            break;
        }
        case 2:
        {
            NewsViewController *newsVC = [[NewsViewController alloc] init];
            newsVC.title = @"学生活动";
            newsVC.listID = @"100";
            [self.navigationController pushViewController:newsVC animated:YES];
            break;
        }
        case 3:
        {
            SchoolViewController *cultureVC = [[SchoolViewController alloc] init];
            cultureVC.title = @"校园文化";
            cultureVC.listID = @"96";
            [self.navigationController pushViewController:cultureVC animated:YES];
            break;
        }
        case 4:
        {
            SchoolViewController *schoolVC = [[SchoolViewController alloc] init];
            schoolVC.title = @"校园风光";
            schoolVC.listID = @"97";
            [self.navigationController pushViewController:schoolVC animated:YES];
            break;
        }
        case 5:
        {
            ClassTableViewController *classTableVC = [[ClassTableViewController alloc] init];
            [self.navigationController pushViewController:classTableVC animated:YES];
            break;
        }
        case 6:
        {
            ExamViewController *examVC = [[ExamViewController alloc] init];
            [self.navigationController pushViewController:examVC animated:YES];
            break;
        }
        case 7:
        {
            ScoreListViewController *scoreVC = [[ScoreListViewController alloc] init];
            [self.navigationController pushViewController:scoreVC animated:YES];
            break;
        }
        case 8:
        {
            AboutViewController *aboutVC = [[AboutViewController alloc] init];
            aboutVC.title = @"更多";
            [self.navigationController pushViewController:aboutVC animated:YES];
            break;
        }
        default:
            break;
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
