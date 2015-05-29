//
//  BaseNavigationController.m
//  DIST
//
//  Created by zhangjianhua on 15/4/11.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {

    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabBarBg"] forBarMetrics:UIBarMetricsDefault];
    //通过背景图片来设置背景
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    UIImage *backgroundImage = [UIImage imageNamed:@"tabBarBg.png"];  //获取图片
    
    if(systemVersion>=5.0)
    {
        CGSize titleSize = self.navigationBar.bounds.size;  //获取Navigation Bar的位置和大小
        backgroundImage = [self scaleToSize:backgroundImage size:titleSize];//设置图片的大小与Navigation Bar相同
        [self.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];  //设置背景
    }
    else
    {
        [self.navigationController.navigationBar insertSubview:[[UIImageView alloc] initWithImage:backgroundImage] atIndex:1];
    }
    UIColor * color = [UIColor whiteColor];
    
    
    
   //这里我们设置的是颜色，还可以设置shadow等，具体可以参见api
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    
   //大功告成
    
    self.navigationBar.titleTextAttributes = dict;
    self.navigationBar.tintColor = [UIColor whiteColor];
}

//调整图片大小
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
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
