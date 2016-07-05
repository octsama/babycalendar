//
//  XXSConfig.m
//  babycalendar
//
//  Created by 君の神様 on 16/5/3.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "XXSConfig.h"

@implementation XXSConfig

+ (instancetype)sharedConfig {
    static XXSConfig *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [XXSConfig new];
        _sharedInstance.userToken = DEFAULTS(object, @"userToken");
    });
    return _sharedInstance;
}

- (void)setUserToken:(NSString *)userToken {
    _userToken = userToken;
    if (!_userToken || [_userToken isEqualToString:@""]) {
        RM_DEFAULTS(@"userToken");
    } else {
        SET_DEFAULTS(Object, @"userToken", _userToken);
    }
}

@end
