//
//  XXSDBManager.m
//  babycalendar
//
//  Created by 君の神様 on 16/2/24.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "XXSDBManager.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "XXSActivityData.h"

@interface XXSDBManager ()

@property (nonatomic, strong)NSString *databasePath;

@end

@implementation XXSDBManager

static dispatch_once_t onceToken;

+ (instancetype)dbManager {
    static XXSDBManager *dbManager = nil;
    dispatch_once(&onceToken, ^{
        dbManager = [[XXSDBManager alloc] init];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        dbManager.databasePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"database.sqlite"]];
        [dbManager createTables];
    });
    return dbManager;
}

- (FMDatabase *)database {
    FMDatabase *db = [FMDatabase databaseWithPath:_databasePath];
    if (![db open]) {
        return nil;
    }
    return db;
}

+ (void)resetManager {
    onceToken = 0;
}

- (void)createTables {
    FMDatabase *db = [self database];
    if (db) {
        [db executeUpdate:@"create table if not exists babybehavior (id integer PRIMARY KEY AutoIncrement,behavior text, createdTime integer, photo blob, userId integer)"];
//        [db executeUpdate:@"create table if not exists User (id integer primary key AutoIncrement,userId integer, userName varchar(255), nickName varchar(255),password varchar(255)"];
        [db close];
    }
}

- (BOOL)insertActivityTableWithModel:(XXSActivityData *)data {
    FMDatabase *db = [self database];
    if (db) {
//        BOOL insert = [db executeUpdate:@"INSERT INTO babybehavior(behavior, createdTime, photo, userId) VALUES (?,?,?,?)",data.behavior,data.createdTime,data.photo,data.userId];
        BOOL insert = [db executeUpdate:@"INSERT INTO babybehavior(behavior, createdTime, photo, userId) VALUES (?,?,?,?);" withArgumentsInArray:@[data.behavior,[NSNumber numberWithInteger:data.createdTime],data.photo,[NSNumber numberWithInteger:data.userId]]];
        [db close];
        if (insert) {
            NSLog(@"Success");
        } else {
            NSLog(@"Fail");
        }
        return insert;
    }
    return NO;
}

- (BOOL)deleteFromTableWithModel:(XXSActivityData *)data {
    FMDatabase *db = [self database];
    if (db) {
        NSString *deleteSql = [NSString stringWithFormat:@"delete from babybehavior where createdTime = %ld",(long)data.createdTime];
        BOOL result = [db executeUpdate:deleteSql];
        if (result) {
            NSLog(@"Success");
        } else {
            NSLog(@"Fail");
        }
        return result;
    }
    return NO;
}

- (NSMutableArray *)queryData {
    FMDatabase *db = [self database];
    NSMutableArray *dataArray = [NSMutableArray array];
    if (db) {
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM babybehavior"];
        while ([resultSet next]) {
            XXSActivityData *data = [[XXSActivityData alloc] init];
            data.behavior = [resultSet stringForColumn:@"behavior"];
            data.createdTime = [resultSet intForColumn:@"createdTime"];
            data.userId = [resultSet intForColumn:@"userId"];
            data.photo = [resultSet dataForColumn:@"photo"];
            [dataArray addObject:data];
        }
    }
    [db close];
    return dataArray;
}

@end
