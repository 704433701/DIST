//
//  ClassInfoInterfaceController.m
//  DIST
//
//  Created by AngelLL on 15/5/28.
//  Copyright (c) 2015年 大连科技学院. All rights reserved.
//

#import "ClassInfoInterfaceController.h"
#import "ClassTable.h"
#import "ClassInfoRowController.h"

@interface ClassInfoInterfaceController ()
@property (strong, nonatomic) IBOutlet WKInterfaceTable *tableView;

@end

@implementation ClassInfoInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    ClassTable *classTable = context;
    [self setTitle:classTable.course];
    
    NSString *week = [NSString stringWithFormat:@"%@-%@周", classTable.beginWeek, classTable.endWeek];
    NSArray *arr = @[classTable.course, week, classTable.time, classTable.classroom, classTable.teacher];
    
    for (NSInteger i = 0; i < arr.count; i++) {
        [_tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:i] withRowType:@"classInfo"];
        ClassInfoRowController *row = [self.tableView rowControllerAtIndex:i];
        [row.infoLabel setText:[arr objectAtIndex:i]];
        [row.imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"class0%ld.png", i]]];
 
    }
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



