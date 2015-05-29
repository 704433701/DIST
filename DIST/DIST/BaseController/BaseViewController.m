//
//  BaseViewController.m
//  DIST
//
//  Created by lanou3g on 15/5/13.
//  Copyright (c) 2015年 大连科技学院. All rights reserved.
//

#import "BaseViewController.h"


@interface BaseViewController ()

@property (nonatomic, retain) LoginViewController *addClassVC;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    UIView *view = nil;
    UIButton *button = nil;
    if (![user objectForKey:@"user"]) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        view.tag = 1000;
        view.backgroundColor = BACKGROUND_COLOR;
        [self.view addSubview:view];
        
        button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(WIDTH / 4, HEIGHT / 2, WIDTH / 2, 50);
        button.tintColor = [UIColor whiteColor];
        button.backgroundColor = [UIColor orangeColor];
        [button addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 5;
        [button setTitle:@"登录教务" forState:UIControlStateNormal];
        [view addSubview:button];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, HEIGHT / 4, WIDTH, HEIGHT / 4)];
        label.text = @"登录之后开启更多功能\n赶快登录吧~";
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [view addSubview:label];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH / 4, 0, WIDTH / 2, WIDTH / 2)];
        imageView.image = [UIImage imageNamed:@"xiaoxun.png"];
        [view addSubview:imageView];

    } else {
        UIView *subviews  = [self.view viewWithTag:1000];
        [subviews removeFromSuperview];
    }
}

- (void)loginAction:(UIButton *)button
{
    LoginViewController *addClassVC = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:addClassVC animated:YES];
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
