//
//  Student.h
//  DIST
//
//  Created by AngelLL on 15/5/24.
//  Copyright (c) 2015年 大连科技学院. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Student : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSString * department;
@property (nonatomic, retain) NSString * profession;
@property (nonatomic, retain) NSString * class_name;
@property (nonatomic, retain) NSString * iconImage;

@end
