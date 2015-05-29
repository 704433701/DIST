//
//  AboutViewController.m
//  DIST
//
//  Created by AngelLL on 15/5/28.
//  Copyright (c) 2015年 大连科技学院. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) NSArray *arr;
@end

@implementation AboutViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.arr = @[@"院长邮箱", @"官方微信", @"新浪微博", @"腾讯微博", @"百度贴吧(非官方)"];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
//    NSInteger height = [[UIScreen mainScreen] bounds].size.height;
//    if (height == 480) {
//        height = 44 * (_arr.count + 1)+ 68 * 2;
//    } else {
//        height = 44 * (_arr.count + 2)+ 68 * 3;
//    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64)];
    imageView.image = [UIImage imageNamed:@"aboutBg.png"];
    [self.view addSubview:imageView];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"about"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return _arr.count;
            break;
        default:
            return 1;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *arr = @[@"互动平台", @"设置", @"关于"];
    return [arr objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"about"];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"about_%ld%ld", indexPath.section, indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor clearColor];
    
    switch (indexPath.section) {
        case 0:
        {
            cell.textLabel.text = [_arr objectAtIndex:indexPath.row];
            return cell;
            break;
        }
        case 1:
        {
            cell.textLabel.text = @"清除缓存";
            return cell;
            break;
        }
            
        default:
        {
            cell.textLabel.text = @"鸣谢";
            return cell;
            break;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            NSString *urlStr = nil;
            switch (indexPath.row) {
                case 0:
                {
                    urlStr = @"mailto://dist@dist.edu.cn";
                    break;
                }
                case 1:
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"微信" message:@"官方微信号：idkter\n官方微信昵称：大连科技学院" delegate:self cancelButtonTitle:nil otherButtonTitles:@"记住了", nil];
                    [alert show];
                    break;
                }
                case 2:
                {
                    urlStr = @"http://weibo.com/dlkjxygjjlxy";
                    break;
                }
                case 3:
                {
                    urlStr = @"http://t.qq.com/DLKJXYGJJLXY";
                    break;
                }
                case 4:
                {
                    urlStr = @"http://tieba.baidu.com/mo/q/m?word=%E5%A4%A7%E8%BF%9E%E7%A7%91%E6%8A%80%E5%AD%A6%E9%99%A2&page_from_search=index&tn6=bdISP&tn4=bdKSW&tn7=bdPSB&lm=16842752&lp=6093&sub4=%E8%BF%9B%E5%90%A7&pn=0&";
                    break;
                }
                default:
                    break;
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
            break;
        }
        case 1:
        {
            // 单例(一个应用程序只有一个对象)
            SDImageCache *sdImageCache = [SDImageCache sharedImageCache];
            
            NSString *str = [NSString stringWithFormat:@"缓存大小%.2fM.是否清除缓存?", [sdImageCache checkTmpSize]];
            NSString *cancelStr = @"取消";
            if ([sdImageCache checkTmpSize] == 0) {
                str = @"您还没有缓存, 不需要清理哦!";
                cancelStr = nil;
            }
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:cancelStr otherButtonTitles:@"确定", nil];
            
            // 这里执行协议方法的对象是这个视图控制器对象(协议方法是给别人用的)
            alertView.delegate = self;
            [alertView show];
            break;
        }
            
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"鸣谢" message:@"大连科技学院 指导教师:秦放\n测试支持:笑**烟,春**冬,21**h8,本**灬" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
            [alert show];
            break;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 1) {
        [[SDImageCache sharedImageCache] clearDisk];
        
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
