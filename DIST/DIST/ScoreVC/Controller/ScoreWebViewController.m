//
//  ScoreWebViewController.m
//  DIST
//
//  Created by AngelLL on 15/5/29.
//  Copyright (c) 2015年 大连科技学院. All rights reserved.
//

#import "ScoreWebViewController.h"

@interface ScoreWebViewController () <UIAlertViewDelegate>

@property (nonatomic, retain) UIWebView *webView;
@end

@implementation ScoreWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64)];
    [self.view addSubview:_webView];
    
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]];
//    [_webView loadRequest:request];
    
    [self requestData];
}

- (void)requestData
{
    // 获取主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    // 获取全局队列
    dispatch_queue_t myQueue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    
    MBProgressHUD *mb = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:mb];
    mb.mode = MBProgressHUDModeIndeterminate;
    [mb show:YES];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    // 异步分发任务
    dispatch_async(myQueue, ^{
        NSURL *url = [NSURL URLWithString:_urlStr];
        NSData *data = [NSData dataWithContentsOfURL:url];
        if (data == nil) {
            dispatch_async(mainQueue, ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"信息加载失败,请检查网络后重试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"返回", nil];
                alert.delegate = self;
                [alert show];
            });
        }
        NSString *transStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        transStr = [transStr stringByReplacingOccurrencesOfString:@"表表" withString:@"i科院"];
        dispatch_async(mainQueue, ^{
            [_webView loadHTMLString:transStr baseURL:url];
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
