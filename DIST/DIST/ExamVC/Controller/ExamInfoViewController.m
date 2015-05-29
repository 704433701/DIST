//
//  ExamInfoViewController.m
//  DIST
//
//  Created by lanou3g on 15/5/11.
//  Copyright (c) 2015年 大连科技学院. All rights reserved.
//

#import "ExamInfoViewController.h"

@interface ExamInfoViewController ()<UIAlertViewDelegate>


@end

@implementation ExamInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"考试通知";
    // Do any additional setup after loading the view.
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64)];
    web.scrollView.bounces = NO;
    [self.view addSubview:web];
    
    // 获取主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    // 获取全局队列
    dispatch_queue_t myQueue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    
    MBProgressHUD *mb = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:mb];
    mb.mode = MBProgressHUDModeIndeterminate;
    [mb show:YES];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *str = [NSString stringWithFormat:@"http://125.222.144.19/student/%@", _info.infoUrl];
    // 异步分发任务
    dispatch_async(myQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
        if (data == nil) {
            dispatch_async(mainQueue, ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"信息加载失败,请检查网络后重试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"返回", nil];
                alert.delegate = self;
                [alert show];
            });
        }
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
        NSString *transStr=[[NSString alloc]initWithData:data encoding:enc];
        NSString *html = [NSString stringWithFormat:@"<meta name=\"format-detection\" content=\"telephone=no\" /> %@", transStr];
        dispatch_async(mainQueue, ^{
            [web loadHTMLString:html baseURL:nil];
            [mb hide:YES];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
    });
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
