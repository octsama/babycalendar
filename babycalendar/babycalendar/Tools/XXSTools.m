//
//  XXSTools.m
//  babycalendar
//
//  Created by 君の神様 on 16/4/9.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "XXSTools.h"
#import "AFNetworkReachabilityManager.h"
#import "XXSConfig.h"

@implementation XXSTools

+ (BOOL)isNetworkReachable {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (BOOL)shouldLoginFirstByPresentingView {
    XXSConfig *config = [XXSConfig sharedConfig];
    if (config.userToken ) {
        return NO;
    } else {
        return YES;
    }
}


@end
