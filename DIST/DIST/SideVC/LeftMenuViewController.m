//
//  MenuViewController.m
//  RESideMenuExample
//
//  Created by Roman Efimov on 10/10/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//
#import "LeftMenuViewController.h"
#import "Student.h"

@interface LeftMenuViewController ()<UITableViewDataSource, UITableViewDelegate, RESideMenuDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RSKImageCropViewControllerDelegate>

@property (nonatomic, retain) UIButton *userIcon;
@property (strong, readwrite, nonatomic) UITableView *tableView;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UIButton *button;

@property (nonatomic, retain) LoginViewController *loginVC;

@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) Student *student;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.userIcon = [UIButton buttonWithType:UIButtonTypeSystem];
    _userIcon.frame = CGRectMake(WIDTH / 4, HEIGHT / 6, WIDTH / 4, WIDTH / 4);
    _userIcon.layer.cornerRadius = WIDTH / 4 / 2;
    _userIcon.clipsToBounds = YES;
    [_userIcon addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_userIcon];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, HEIGHT / 6 + WIDTH / 4, WIDTH * 2 / 3, 54 * 4) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, HEIGHT - 40, WIDTH, 30)];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = [UIColor whiteColor];
    _label.font = [UIFont systemFontOfSize:16];
    _label.text = @"大连市旅顺经济开发区滨港路999-26号";
    [self.view addSubview:_label];
    [self.view addSubview:self.tableView];
    
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    _button.layer.cornerRadius = 5;
    _button.tintColor = [UIColor whiteColor];
    [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    
    self.sideMenuViewController.delegate = self;
}


- (void)buttonAction:(UIButton *)button
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];

    if ([user objectForKey:@"user"]) {
        
        // 删除用户账号密码
        [user setObject:nil forKey:@"user"];
        [user setObject:nil forKey:@"pwd"];
        
        // 删除用户头像
        SDImageCache *cache = [SDImageCache sharedImageCache];
        [cache removeImageForKey:_student.iconImage];
        
        // 删除用户本地信息
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
    } else {
        self.loginVC = [[LoginViewController alloc] init];
        BaseNavigationController *navi = [[BaseNavigationController alloc] initWithRootViewController:_loginVC];
        _loginVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-xiangxia (1).png"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
        [self presentViewController:navi animated:YES completion:nil];

    }

    [self data];
}

- (void)backAction:(UIBarButtonItem *)bar
{
    [_loginVC dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    _button.frame = CGRectMake(50, HEIGHT, WIDTH * 2 / 3 - 60, 0);
    [self data];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self data];
}

#pragma mark - 更新数据
- (void)data
{
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    self.context = app.managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    NSArray *classArr = [self.context executeFetchRequest:request error:nil];
    self.student = [classArr lastObject];
    
    [UIView animateWithDuration:0.6 animations:^{
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"user"]) {
            _button.frame = CGRectMake(50, 54 * 4 + HEIGHT / 6 + WIDTH / 4 + 10, WIDTH * 2 / 3 - 60, 40);
            _button.backgroundColor = [UIColor colorFromHexCode:@"#f15b6c"alpha:0.6];
            [_button setTitle:@"退出登录" forState:UIControlStateNormal];
        } else {
            _button.frame = CGRectMake(50, HEIGHT / 6 + WIDTH / 4 + 30, WIDTH * 2 / 3 - 60, 40);
            _button.backgroundColor = [UIColor colorFromHexCode:@"#a3cf62"];
            [_button setTitle:@"登录教务" forState:UIControlStateNormal];
        }
    } completion:^(BOOL finished) {
        [_userIcon sd_setBackgroundImageWithURL:[NSURL URLWithString:_student.iconImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"iconfont-iconfontcolor19.png"]];
        
        [_tableView reloadData];
    }];

}
#pragma mark - 编辑头像
- (void)editAction:(UIButton *)button
{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        pickerImage.delegate = self;
        pickerImage.allowsEditing = NO;
        [self presentViewController:pickerImage animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //取出选中图片
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image];
    imageCropVC.delegate = self;
    [picker pushViewController:imageCropVC animated:YES];
}

#pragma mark - RSKImageCropViewControllerDelegate

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [controller.navigationController popViewControllerAnimated:YES];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect
{
    
    [_userIcon setBackgroundImage:croppedImage forState:UIControlStateNormal];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager saveImageToCache:croppedImage forURL:[NSURL URLWithString:_student.iconImage]];

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if (_student) {
        return 4;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *titles = @[_student.name, _student.number, _student.department, _student.class_name];
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.text = titles[indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
     //   cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
        return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


@end
