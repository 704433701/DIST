//
//  DataBaseHandler.h
//  UI18_DataBase
//
//  Created by 琳琳是笨蛋 on 15-3-12.
//  Copyright (c) 2015年 lanou3g.com 蓝鸥科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassTable.h"
// 引入系统的库文件, 要使用import< >
#import <sqlite3.h>

// 数据库管理类
// 所有有关于数据库的方法和操作都在这个类里面
@interface DataBaseHandler : NSObject
{
    // 数据库文件指针, 可以通过它读取本地的数据库文件
    sqlite3 *dbPoint;
}

// 一个单例方法, 只能通过这个方法获取这个类的对象
+ (DataBaseHandler *)shareInstance;

// 打开数据库
- (void)opernDB;
// 关闭数据库
- (void)closeDB;
// 查询所有的学生数据
- (NSMutableArray *)selectAllClass:(NSInteger)week;


@end
