//
//  ClassInfoViewController.m
//  DIST
//
//  Created by AngelLL on 15/5/27.
//  Copyright (c) 2015年 大连科技学院. All rights reserved.
//

#import "ClassInfoViewController.h"

#define ViewFrame_WIDTH _bgView.frame.size.width
#define cellFrame_HEIGHT _bgView.frame.size.height / (_arr.count + 1)

@interface ClassInfoViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UIView *bgView;
@property (nonatomic, retain) UIView *beforeView;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIImageView *headerView;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UIImageView *imageView;

@property (nonatomic, retain) NSArray *arr;


@end

@implementation ClassInfoViewController

- (id)initWithClassInfo:(ClassTable *)classInfo
{
    self = [super init];
    if (self) {
        self.title = classInfo.course;
         self.arr = @[classInfo.teacher, [NSString stringWithFormat:@"%@ - %@周", classInfo.beginWeek,  classInfo.endWeek], classInfo.time, classInfo.classroom];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view.
    self.bgView = [[UIView alloc] initWithFrame:_viewFrame];
    
    _bgView.layer.cornerRadius = 10;
    _bgView.clipsToBounds = YES;
    [self.view addSubview:_bgView];
    
    self.headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ViewFrame_WIDTH, cellFrame_HEIGHT)];
    _headerView.userInteractionEnabled = YES;
    _headerView.image = [UIImage imageNamed:@"tabBarBg"];
    [self.bgView addSubview:_headerView];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ViewFrame_WIDTH, cellFrame_HEIGHT)];
    _label.text = self.title;
    _label.userInteractionEnabled = YES;
    _label.textColor = [UIColor whiteColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont boldSystemFontOfSize:20];
    [self.headerView addSubview:_label];
    
    CGRect frame = CGRectMake(0, _headerView.frame.size.height, ViewFrame_WIDTH, cellFrame_HEIGHT * _arr.count);
    self.imageView = [[UIImageView alloc] initWithFrame:frame];
    _imageView.image = [UIImage imageNamed:@"classInfoBg"];
    [self.bgView addSubview:_imageView];
    
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    // _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.bgView addSubview:_tableView];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"classInfo"];
    
    self.beforeView = [[UIView alloc] initWithFrame:_bgView.frame];
    _beforeView.backgroundColor = [UIColor blackColor];
    _beforeView.layer.cornerRadius = 5;
    [self.view addSubview:_beforeView];
    
    [UIView animateWithDuration:0.5 animations:^{
        _bgView.frame = CGRectMake(WIDTH / 6, 0, WIDTH * 2 / 3, WIDTH * 2 / 3);
        _bgView.center = CGPointMake(self.view.center.x, self.view.center.y - 64);
        [self changeFrame];
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        self.beforeView.backgroundColor = [UIColor clearColor];
    }];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self closeAction];
}

- (void)closeAction
{
    [UIView animateWithDuration:0.5 animations:^{
        _bgView.frame = _viewFrame;
        [self changeFrame];
        self.view.backgroundColor = [UIColor clearColor];
        _beforeView.backgroundColor = [UIColor blackColor];
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (void)changeFrame
{
    _headerView.frame = CGRectMake(0, 0, ViewFrame_WIDTH, cellFrame_HEIGHT);
    _label.frame = CGRectMake(0, 0, ViewFrame_WIDTH, cellFrame_HEIGHT);
    CGRect frame = CGRectMake(0, _headerView.frame.size.height, ViewFrame_WIDTH, cellFrame_HEIGHT * _arr.count);
    _imageView.frame = frame;
    _tableView.frame = frame;
    _beforeView.frame = _bgView.frame;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"classInfo"];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [_arr objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.numberOfLines = 2;
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"class%ld", indexPath.row + 1]];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellFrame_HEIGHT;
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
