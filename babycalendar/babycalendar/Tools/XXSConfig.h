//
//  XXSConfig.h
//  babycalendar
//
//  Created by 君の神様 on 16/5/3.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXSConfig : NSObject

@property(nonatomic, strong) NSString *userToken;

+ (instancetype)sharedConfig;

@end
