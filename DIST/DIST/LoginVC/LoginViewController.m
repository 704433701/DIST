//
//  AddClassViewController.m
//  DIST
//
//  Created by 张健华 on 15/5/5.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "LoginViewController.h"
#import "ClassTable.h"
#import "Student.h"

@interface LoginViewController ()

@property (nonatomic, retain) UITextField *userText;
@property (nonatomic, retain) UITextField *pwdText;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.title = @"大连科技学院";
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
    label.backgroundColor = [UIColor orangeColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"登录教务系统";
    [self.view addSubview:label];
    
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 10, 50, 70, 50)];
    userLabel.text = @"登录名:";
    [self.view addSubview:userLabel];
    
    self.userText = [[UITextField alloc] initWithFrame:CGRectMake(WIDTH / 10 + 70, 60, WIDTH - WIDTH / 5 - 70, 30)];
    [_userText becomeFirstResponder];
    _userText.placeholder = @"请输入学号";
    //_userText.text = @"1306070203";
    _userText.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_userText];
    
    UILabel *pwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 10, 100, 70, 50)];
    pwdLabel.text = @"密    码:";
    [self.view addSubview:pwdLabel];
    
    self.pwdText = [[UITextField alloc] initWithFrame:CGRectMake(WIDTH / 10 + 70, 60 + 50, WIDTH - WIDTH / 5 - 70, 30)];
    _pwdText.placeholder = @"请输入密码";
    //_pwdText.text = @"wqxi8bqwk";
    _pwdText.secureTextEntry = YES;
    _pwdText.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_pwdText];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [loginButton setTitle:@"登     录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    loginButton.layer.cornerRadius = 6;
    loginButton.backgroundColor = [UIColor orangeColor];
    loginButton.frame = CGRectMake(WIDTH / 10 , 110 + 50, WIDTH * 4 / 5, 40);
    [self.view addSubview:loginButton];
    
    UILabel *pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 10, 200, WIDTH * 4 / 5, 150)];
    pointLabel.numberOfLines = 0;
    pointLabel.text = @"提示: 输入学校的学号和密码, 登录您的教务系统。务必牢记账户名称、使用密码.  如果您还不知道或者忘记密码, 请自行联系辅导员索取。教务功能暂只支持12、13级使用, 敬请谅解";
    [self.view addSubview:pointLabel];
    
}

- (void)loginAction:(UIButton *)button
{
    [self.view endEditing:YES];
    [self requestData];
}

#pragma mark - 请求数据
- (void)requestData
{
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
   self.context = app.managedObjectContext;
    // 获取wifi的菊花圈
    if (_userText.text.length == 0 || _pwdText.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录名和密码不能为空" delegate:self cancelButtonTitle:nil otherButtonTitles:@"重试", nil];
        [alert show];
        [_userText becomeFirstResponder];
    } else {
        MBProgressHUD *mb = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:mb];
        mb.mode = MBProgressHUDModeIndeterminate;
        mb.labelText = @"验证登录...";
        [mb show:YES];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        NSDictionary *dict = @{ @"username":_userText.text, @"password":_pwdText.text, @"mynum":@"1"};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:@"http://125.222.144.19/userlog.asp" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([operation.response.URL isEqual:[NSURL URLWithString:@"http://125.222.144.19/student/index.asp"]]) {
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user setObject:_userText.text forKey:@"user"];
                [user setObject:_pwdText.text forKey:@"pwd"];
                [user synchronize];
                // 下载个人信息
                [manager GET:@"http://125.222.144.19/student/basinfo.asp" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSEntityDescription *description = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:self.context];
                    NSFetchRequest *request = [[NSFetchRequest alloc] init];
                    [request setIncludesPropertyValues:NO];
                    [request setEntity:description];
                    NSError *error = nil;
                    NSArray *datas = [_context executeFetchRequest:request error:&error];
                    if (!error && datas && [datas count])
                    {
                        for (NSManagedObject *obj in datas)
                        {
                            [_context deleteObject:obj];
                        }
                        if (![_context save:&error])
                        {
                            NSLog(@"error:%@",error);
                        }
                    }
                    TFHpple *xpathParser = [[TFHpple alloc]initWithHTMLData:responseObject];
                    NSArray *contentArray = [xpathParser searchWithXPathQuery:@"//font"];
                    NSArray *imageArray = [xpathParser searchWithXPathQuery:@"//img"];
                    NSString *urlstr = [[imageArray firstObject] objectForKey:@"src"];
                    urlstr = [urlstr stringByReplacingOccurrencesOfString:@".." withString:@""];
                    urlstr = [@"http://125.222.144.19" stringByAppendingString:urlstr];

                    Student *stu = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.context];
                    NSMutableArray *arr = [NSMutableArray array];
                    for (TFHppleElement *element in contentArray) {
                        NSString *str = [element content];
                        str = [str stringByReplacingOccurrencesOfString:@"&nbsp" withString:@""];
                        if (str.length <= 0) {
                            str = @"null";
                        }
                        [arr addObject:str];
                    }
                    
                    stu.name = [[[[contentArray objectAtIndex:10] children] lastObject] content];
                    stu.number = [arr objectAtIndex:3];
                    stu.department = [arr objectAtIndex:1];
                    stu.profession = [arr objectAtIndex:5];
                    stu.class_name = [arr objectAtIndex:7];
                    stu.iconImage = urlstr;
                    [self.context save:nil];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
                
                
                // 下载课表
                [manager GET:@"http://125.222.144.19/student/kcb.asp" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    NSEntityDescription *description = [NSEntityDescription entityForName:@"ClassTable" inManagedObjectContext:self.context];
                    NSFetchRequest *request = [[NSFetchRequest alloc] init];
                    [request setIncludesPropertyValues:NO];
                    [request setEntity:description];
                    NSError *error = nil;
                    NSArray *datas = [_context executeFetchRequest:request error:&error];
                    if (!error && datas && [datas count])
                    {
                        for (NSManagedObject *obj in datas)
                        {
                            [_context deleteObject:obj];
                        }
                        if (![_context save:&error])
                        {
                            NSLog(@"error:%@",error);
                        }
                    }
                    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
                    NSString *htmlStr=[[NSString alloc]initWithData:responseObject encoding:enc];
                    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
                    NSString *headerEx = @"<font[^>]+size=\"2\">\\r\\w*";
                    NSRegularExpression *headerex = [NSRegularExpression regularExpressionWithPattern:headerEx options:NSRegularExpressionCaseInsensitive error:&error];
                    NSArray *headerArr = [headerex matchesInString:htmlStr options:0 range:NSMakeRange(0, [htmlStr length])];
                    
                    NSString *footerEx = @"&nbsp</td>";
                    NSRegularExpression *footerex = [NSRegularExpression regularExpressionWithPattern:footerEx options:NSRegularExpressionCaseInsensitive error:&error];
                    NSArray *footerArr = [footerex matchesInString:htmlStr options:0 range:NSMakeRange(0, [htmlStr length])];
                    for (NSInteger i = 0; i < 49; i++) {
                        NSTextCheckingResult *header = [headerArr objectAtIndexedSubscript:i];
                        NSTextCheckingResult *footer = [footerArr objectAtIndexedSubscript:i + 1];
                        NSString *str = [htmlStr substringWithRange:NSMakeRange(header.range.location + header.range.length, footer.range.location - header.range.location - header.range.length)];
                        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                        str = [str stringByReplacingOccurrencesOfString:@"\r→" withString:@""];
                        
                        [self strHandle:str number:i];
                    }
                    mb.mode = MBProgressHUDModeCustomView;
                    mb.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hubyes.png"]];
                    mb.labelText = @"登录成功";
                    [mb showAnimated:YES whileExecutingBlock:^{
                        sleep(1);
                    } completionBlock:^{
                        [mb hide:YES afterDelay:2];
                        [self.navigationController popViewControllerAnimated:YES];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [mb hide:NO];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求频繁, 请稍后重试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
                    [alert show];
                    [_userText becomeFirstResponder];
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                }];
            } else {
                [mb hide:NO];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录名或密码错误, 请重试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"重试", nil];
                [alert show];
                [_userText becomeFirstResponder];
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [mb hide:YES afterDelay:1];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络错误, 请检查网络后重试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
            [alert show];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }];
        
    }
}

#pragma mark - 课表字符串处理方法
- (void)strHandle:(NSString *)str number:(NSInteger)number
{
    
    // 将字符串切割成不同Model属性
    NSArray *timeArr = @[@"1-2节 8:20~9:55", @"3-4节 10:10~11:45", @"5-6节 13:50~15:25", @"7-8节 15:40~17:15", @"9-10节 6:10~19:45", @"11-12节", @"13-14节"];
    NSArray *arr = [str componentsSeparatedByString:@"\r"];
    
    if ([[arr firstObject] isEqualToString:@""]) {
        ClassTable *class = [NSEntityDescription insertNewObjectForEntityForName:@"ClassTable" inManagedObjectContext:self.context];
        class.number = @(number);
        class.time = [timeArr objectAtIndex:number / 7];
    } else {
    for (NSInteger i = 0; i < arr.count; i++) {
        if ([[arr objectAtIndex:i] hasPrefix:@"("]) {
            ClassTable *class = [NSEntityDescription insertNewObjectForEntityForName:@"ClassTable" inManagedObjectContext:self.context];
            class.number = @(number);
            class.time = [timeArr objectAtIndex:number / 7];
            // 用正则表达式找出课程开始周数beginWeek和结束周数endWeek
            NSString *headerEx = @"\\d+";
            NSError *error = NULL;
            NSRegularExpression *headerex = [NSRegularExpression regularExpressionWithPattern:headerEx options:NSRegularExpressionCaseInsensitive error:&error];
            NSArray *weekArr = [headerex matchesInString:[arr objectAtIndex:i] options:0 range:NSMakeRange(0, [[arr objectAtIndex:i] length])];
            NSRange beginweekRange = [[weekArr firstObject] range];
            NSRange endweekRange = [[weekArr objectAtIndex:1] range];
            class.teacher = [[arr objectAtIndex:i] substringFromIndex:endweekRange.location + endweekRange.length + 1];
            class.course = [arr objectAtIndex:i + 1];
            class.classroom = [arr objectAtIndex:i + 2];
            class.beginWeek = @([[[arr objectAtIndex:i] substringWithRange:beginweekRange] integerValue]);
            class.endWeek = @([[[arr objectAtIndex:i] substringWithRange:endweekRange] integerValue]);
        }
    }
    }
    [self.context save:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
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
