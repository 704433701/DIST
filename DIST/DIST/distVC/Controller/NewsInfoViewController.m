//
//  NewsInfoViewController.m
//  DIST
//
//  Created by zhangjianhua on 15/4/14.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "NewsInfoViewController.h"

@interface NewsInfoViewController() <UIWebViewDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) UIWebView *webView;

@end

@implementation NewsInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.news.title;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64)];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    _webView.scrollView.bounces = NO;
    [self.view addSubview:_webView];
    
    [self requestData];

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    return YES;
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
    // 异步分发任务
    dispatch_async(myQueue, ^{
        NSString *urlStr = [NSString stringWithFormat:@"http://www.ieidjtu.edu.cn%@", self.news.ID];
        [NetHandler getDataWithUrl:urlStr completion:^(NSData *data) {
            
            NSString *tou = @"<meta charset=\"UTF-8\">";
            NSString *htmlStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            if (htmlStr.length != 0) {
                NSRange rangeHeader = [htmlStr rangeOfString:@"<h2 class=\"info-title\">"];//匹配得到的下标
                NSRange rangeFooter = [htmlStr rangeOfString:@"</p></ul>"];//匹配得到的下标
                if (rangeFooter.length == 0) {
                    rangeFooter = [htmlStr rangeOfString:@"</div></ul>"];
                }
                NSRange range = NSMakeRange(rangeHeader.location, rangeFooter.location + rangeFooter.length - rangeHeader.location);
                htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"<h2 class=\"info-title\">" withString:@"<h1 class=\"info-title\" style =\"text-align:center\">"];
                htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"<h2 class=\"info-title-x\">" withString:@"<h6 class=\"info-title-x\" style =\"text-align:center\">"];
                htmlStr = [htmlStr substringWithRange:range];//截取范围类的字符串
                htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"<o:p></o:p>" withString:@""];
                htmlStr = [tou stringByAppendingString:htmlStr];
            }
            //   NSLog(@"%@", htmlStr);
            dispatch_async(mainQueue, ^{
                if (htmlStr.length == 0) {
                    dispatch_async(mainQueue, ^{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"信息加载失败,请检查网络后重试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"返回", nil];
                        alert.delegate = self;
                        [alert show];
                    });
                }
                [_webView loadHTMLString:htmlStr baseURL:[NSURL URLWithString:urlStr]];
                [mb hide:YES];
            });
        }];
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


@end

