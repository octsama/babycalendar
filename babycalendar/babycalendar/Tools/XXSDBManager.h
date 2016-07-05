//
//  XXSDBManager.h
//  babycalendar
//
//  Created by 君の神様 on 16/2/24.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XXSActivityData;

@interface XXSDBManager : NSObject

+ (instancetype)dbManager;
- (BOOL)insertActivityTableWithModel:(XXSActivityData *)data;
- (BOOL)deleteFromTableWithModel:(XXSActivityData *)data;
- (NSMutableArray *)queryData;

@end
