//
//  ClassTable.h
//  DIST
//
//  Created by lanou3g on 15/5/9.
//  Copyright (c) 2015年 大连科技学院. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ClassTable : NSManagedObject

@property (nonatomic, retain) NSNumber * beginWeek;
@property (nonatomic, retain) NSString * classroom;
@property (nonatomic, retain) NSString * course;
@property (nonatomic, retain) NSNumber * endWeek;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSString * teacher;
@property (nonatomic, retain) NSString * time;

@end
