//
//  ViewController.m
//  fmdbDemo
//
//  Created by tyhmeng on 17/1/12.
//  Copyright © 2017年 tyhmeng. All rights reserved.
//

#import "ViewController.h"
#import "FMDB.h"



@interface ViewController ()


@property (nonatomic,strong) FMDatabase *db;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//获取文件路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *dataPath = [path stringByAppendingPathComponent:@"person.sqlite"];
    NSLog(@"===%@",dataPath);
//    获取数据库
    FMDatabase *dataBase = [FMDatabase databaseWithPath:dataPath];
    
    
//    打开数据库
    
    if ([dataBase open]) {
        
//     创建表
        BOOL result = [dataBase executeUpdate:@"CREATE TABLE IF NOT EXISTS t_pers (id integer PRIMARY KEY AUTOINCREMENT,name text NOT NULL,age integer NOT NULL);"];
        
        if (result) {
            NSLog(@"创表成功");
            
        }else {
        
            NSLog(@"创表失败");
        
        }
        
    }
    self.db = dataBase;

}

//增加数据
- (IBAction)click1:(id)sender {
    
    for (int i = 0; i < 10; i ++) {
        
        NSString *name = [NSString stringWithFormat:@"lucy-%d",arc4random_uniform(100)];
        [self.db executeUpdate:@"INSERT INTO t_pers (name,age) VALUES (?,?);",name,@(arc4random_uniform(20))];
        
    }
    
}

//删除数据

- (IBAction)click2:(id)sender {
[self.db executeUpdate:@"DROP TABLE IF EXISTS t_pers;"];
    [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_pers (id integer PRIMARY KEY AUTOINCREMENT,name text NOT NULL,age integer NOT NULL);"];
    
    
}

//查询数据
- (IBAction)click3:(id)sender {
    
    FMResultSet *resultSet = [self.db executeQuery:@"SELECT *FROM t_pers"];
//    遍历结果
    while ([resultSet next]) {
        
//        如果ID设置为逐渐，且设置为自动增长的话，那么把表中的数据删除后，重新插入新的数据，ID的编号不是从0开始，而是接着之前的ID进行编号。
        int ID = [resultSet intForColumn:@"id"];
        NSString *name = [resultSet stringForColumn:@"name"];
        int age = [resultSet intForColumn:@"age"];
        NSLog(@"%d,%@,%d",ID,name,age);
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
