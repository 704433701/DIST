//
//  DataBaseHandler.m
//  UI18_DataBase
//
//  Created by 琳琳是笨蛋 on 15-3-12.
//  Copyright (c) 2015年 lanou3g.com 蓝鸥科技. All rights reserved.
//

#import "DataBaseHandler.h"

@implementation DataBaseHandler

+ (DataBaseHandler *)shareInstance
{
    // 单例方法的实现
    static DataBaseHandler *dbHandler = nil;
    
    // 当静态的指针为空的时候, 创建一个对象
    if (dbHandler == nil) {
        dbHandler = [[DataBaseHandler alloc] init];
    }
    return dbHandler;
}

- (void)opernDB
{
    // 打开数据库
    
    // 拼接一个数据库路径
    
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.DIST.ClassTable"];
    containerURL = [containerURL URLByAppendingPathComponent:@"DIST.db"];
 //   NSString *str = [NSString stringWithContentsOfURL:containerURL encoding:NSUTF8StringEncoding error:&err];
    // 参数1: 要打开的数据库的路径
    NSString *str = [NSString stringWithFormat:@"%@", containerURL];
    NSLog(@"%@", str);
    int result = sqlite3_open([str UTF8String], &dbPoint);
    [self judgeResult:result type:@"open"];
}

- (void)closeDB
{
    // 关闭数据库
    int result = sqlite3_close(dbPoint);
    [self judgeResult:result type:@"关闭数据库"];
}

- (void)judgeResult:(int)result type:(NSString *)type
{
    // 判断结果的方法
    if (result == SQLITE_OK) {
        NSLog(@"%@ OK", type);
    } else {
        NSLog(@"%@失败, %d", type, result);
    }
}


- (NSMutableArray *)selectAllClass:(NSInteger)week
{
    // 查询所有的学生数据
    
    NSString *sqlStr = [NSString stringWithFormat:@"select * from ZCLASSTABLE where ZBEGINWEEK <= %ld and ZENDWEEK >= %ld", week, week];
    
    // 数据库的状态指针, 数据库执行sql语句的所有结果都保存在这个指针中.
    sqlite3_stmt *stmt = nil;
    
    // 执行sql语句, 把sql语句的执行结果保存在stmt中.
    // 参数1: 数据库指针
    // 参数2: sql语句
    // 参数3: 限制sql语句的长度
    // 参数4: stmt的指针地址
   int result = sqlite3_prepare(dbPoint, [sqlStr UTF8String], -1, &stmt, NULL);
    
    // 建立一个空数组, 用来装学生数据
    NSMutableArray *classArr = [NSMutableArray array];
    if (result == SQLITE_OK) {
        
        // 遍历结果中的所有数据
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            ClassTable *classtable = [[ClassTable alloc] init];
            // 每一条数据都对应一个student对象
                    // 按照列的顺序读取
            // 参数1: 状态指针
            // 参数2: 从第几列中取值(从0开始计数)
            NSInteger number = sqlite3_column_int(stmt, 5);
            classtable.number = @(number);
            
            const unsigned char *classroom = sqlite3_column_text(stmt, 6);
            classtable.classroom = [NSString stringWithUTF8String:(const char *)classroom];
            
            const unsigned char *course = sqlite3_column_text(stmt, 7);
            classtable.course = [NSString stringWithUTF8String:(const char *)course];
            
            const unsigned char *time = sqlite3_column_text(stmt, 9);
            classtable.time = [NSString stringWithUTF8String:(const char *)time];
            [classArr addObject:classtable];
        }
    }
    
    // 回收状态指针的内存, 将sql的改变结果保存到数据库.
    sqlite3_finalize(stmt);
    return classArr;
}

@end
