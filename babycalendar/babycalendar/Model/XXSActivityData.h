//
//  XXSActivityData.h
//  babycalendar
//
//  Created by 君の神様 on 16/5/7.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 behavior varchar(255), createdTime integer, photo blob, userId integer
 */

@interface XXSActivityData : NSObject

@property (nonatomic, copy)NSString *behavior;
@property (nonatomic, assign)NSInteger createdTime;
@property (nonatomic, strong)NSData *photo;
@property (nonatomic, assign)NSInteger userId;

@end
