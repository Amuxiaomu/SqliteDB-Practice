//
//  ViewController.m
//  SqliteDB
//
//  Created by Amuxiaomu on 16/7/27.
//  Copyright © 2016年 Amuxiaomu. All rights reserved.
//

#import "ViewController.h"
#import <sqlite3.h>
@interface ViewController ()

{
    sqlite3 * _db;
}

@property (nonatomic, assign) NSInteger delInt;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.创建数据库DB
    /*
     1. DB 文件路径
     2. 数据库对象
     */
    
    NSString * filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"demo.db"];
    
    int result = sqlite3_open(filePath.UTF8String,&_db);
    self.delInt = 1;
    
}
- (IBAction)createButton:(id)sender {
    [self createDB];
}
- (IBAction)insetButton:(id)sender {
    [self insertClickDB];
}
- (IBAction)deleteButton:(id)sender {
    [self deleteDB];
}
- (IBAction)queryButton:(id)sender {
    [self queryDB];
}

- (void)insertClickDB{
    
    NSInteger randowm = arc4random()%2;
    NSLog(@"%d",randowm);
    randowm = 1;
    if (randowm ==0) {
        // 方法一
        char *errorMSG;
        NSString * sql = @"insert into t_student (stuName,stuAge) values ('jim',19)";
        sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &errorMSG);
        if (errorMSG) {
            NSLog(@"(方法一)插入数据库出错:%s",errorMSG);
        }else{
            NSLog(@"(方法一)成功插入一条数据");
        }
        
    }else{
        // 方法二
        NSString * sql = @"insert into t_student (stuName,stuAge) values (?,?)";
        
        sqlite3_stmt *_stmt;
        
        int result = sqlite3_prepare_v2(
                                        _db,            /* Database handle */
                                        sql.UTF8String,       /* SQL statement, UTF-8 encoded */
                                        -1,              /* Maximum length of zSql in bytes. */
                                        &_stmt,  /* OUT: Statement handle */
                                        NULL    /* OUT: Pointer to unused portion of zSql */
                                        );
        if (result == SQLITE_OK) {
            // 参数绑定
            /*
             1. sqlite3_stmt
             2. 第几个占位符 1 开始
             3. 字符串的值
             4. 字符串场地 -1
             5. 回调函数
             */
            sqlite3_bind_text(_stmt,1,"jim2",-1,NULL);
            
            sqlite3_bind_int(_stmt,2,20);
            
            if (sqlite3_step(_stmt) == SQLITE_DONE) {
                NSLog(@"(方法二)成功插入一条数据");
            }else{
                NSLog(@"(方法二)插入数据库失败");
            }
            
        }
        //销毁
        sqlite3_finalize(_stmt);
    }
    
}

- (void)deleteDB{
    char * erorMSG;
    NSString * sql = @"delete from t_student where stuNo = 1";
    
    NSString * sql1= [NSString stringWithFormat:@"delete from t_student where stuNo = %ld",(long)self.delInt];
    sqlite3_exec(_db, sql1.UTF8String, NULL, NULL, &erorMSG);
    if (erorMSG) {
        NSLog(@"删除数据出错:%s",erorMSG);
    }else {
        NSLog(@"删除数据成功");
    }
}

- (void)queryDB{
    // 查询数据
    NSString * sql = @"select * from t_student";
    /*
     */
    sqlite3_stmt * _stmt;
    int result = sqlite3_prepare_v2(_db, sql.UTF8String, -1, &_stmt, NULL);
    
    if (result == SQLITE_OK) {
        //数据集合是一条条的取
        while (sqlite3_step(_stmt) == SQLITE_ROW) {
            // 取每行额数据
            /*
             1. stmt
             2. 哪一行的index
             */
            int stuNo = sqlite3_column_int(_stmt,0);
            const unsigned char * stuName = sqlite3_column_text(_stmt,1);
            int stuAge = sqlite3_column_int(_stmt,2);
            
            self.delInt = stuNo;
            NSLog(@"%d,%s,%d",stuNo,stuName,stuAge);
            
        }
    }
}

- (void)createDB{
   
    
    // 2.建表
    char *errorMSG;
    NSString * sql = @"CREATE TABLE if not exists t_student('stuNO' integer primary key autoincrement,'stuName' text,'stuAge' integer)";
    
    /*
     1. sqlite3*
     2. sql
     3. 回调函数
     4. 回调函数 第一个参数
     5. 错误信息
     */
    sqlite3_exec(
                 _db,                                  /* An open database */
                 sql.UTF8String,                           /* SQL to be evaluated */
                 NULL,  /* Callback function */
                 NULL,                                    /* 1st argument to callback */
                 &errorMSG                              /* Error msg written here */
                 );
    
    
    if (errorMSG) {
        NSLog(@"%s",errorMSG);
    }else{
        NSLog(@"数据库创建成功!");
    }
    
}

@end






