//
//  BaseTabBarController.m
//  DIST
//
//  Created by zhangjianhua on 15/4/11.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "BaseTabBarController.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabBarBg"] forBarMetrics:UIBarMetricsDefault];
    //通过背景图片来设置背景
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    UIImage *backgroundImage = [UIImage imageNamed:@"tabBarBg.png"];  //获取图片
    
    if(systemVersion>=5.0)
    {
        CGSize titleSize = self.tabBar.bounds.size;  //获取Navigation Bar的位置和大小
        backgroundImage = [self scaleToSize:backgroundImage size:titleSize];//设置图片的大小与Navigation Bar相同
        self.tabBar.backgroundImage = backgroundImage;  //设置背景
    }
    else
    {
        [self.navigationController.navigationBar insertSubview:[[UIImageView alloc] initWithImage:backgroundImage] atIndex:1];
    }
    self.tabBar.tintColor = [UIColor whiteColor];
    
}

//调整图片大小
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(- 5, 0, size.width + 10, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
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
