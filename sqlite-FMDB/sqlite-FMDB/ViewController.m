//
//  ViewController.m
//  sqlite-FMDB
//
//  Created by Zijia Zhai on 4/5/16.
//  Copyright © 2016 Zijia Zhai. All rights reserved.
//

#import "ViewController.h"
#import <sqlite3.h>

#import "FMDB.h"

@interface ViewController ()
- (IBAction)createData:(id)sender;
- (IBAction)deleteData:(id)sender;

- (IBAction)searchData:(id)sender;
- (IBAction)updateData:(id)sender;

@property (nonatomic, strong) FMDatabase *database;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //1.FMDB
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"datafmdb.sqlite"];
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    self.database = database;
    BOOL success =  [database open];
    if (success) {
        NSLog(@"创建数据库成功!");
        //非查询语句都是用executeUpdate
        BOOL successT=  [self.database executeUpdate:@"CREATE   TABLE IF NOT EXISTS t_student(id INTEGER PRIMARY KEY AUTOINCREMENT ,name TEXT NOT NULL , score REAL);"];
        if (successT) {
            NSLog(@"创建表成功!");
        }else{
            NSLog(@"创建表失败!!");
        }
        
    }else{
        NSLog(@"创建失败!");
    }

}


- (IBAction)createData:(id)sender {
    
    for (int  i = 0; i < 100; i++) {
        
        NSString *name = [NSString stringWithFormat:@"xiaoli-%d",i];
        
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_student (name,score) VALUES ('%@',%f)",name,arc4random_uniform(8000)/100.0 + 20];
        BOOL success =  [self.database executeUpdate:sql];
        if (success) {
            NSLog(@"添加数据成功!");
        }else{
            NSLog(@"添加数据失败!!");
        }
    }

}

- (IBAction)deleteData:(id)sender {
    
    NSString *sql = @"DELETE FROM t_student WHERE score > 90.0;";
    
    BOOL success =  [self.database executeUpdate:sql];
    
    if (success) {
        NSLog(@"删除数据成功!");
    }else{
        NSLog(@"删除数据失败!!");
    }

}

- (IBAction)searchData:(id)sender {
    
    NSString *sql = @"SELECT  id,name,score FROM t_student WHERE score > 60 AND score < 75;";
    
    
    FMResultSet *result = [self.database executeQuery:sql];
    while ([result next]) {
        
        //name TEXT
        
        NSString *name =   [result stringForColumnIndex:1];
        
        //score DOUBLE
        double score =  [result doubleForColumnIndex:2];
        
        NSLog(@"name = %@ score =  %f",name,score);
        
    }

}

- (IBAction)updateData:(id)sender {
    
    NSString *sql = @"UPDATE t_student SET score = 59.9 WHERE score < 60;";
    BOOL success =  [self.database executeUpdate:sql];
    
    if (success) {
        NSLog(@"修改数据成功!");
    }else{
        NSLog(@"修改数据失败!!");
    }

}
@end
