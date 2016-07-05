//
//  AppDelegate.h
//  babycalendar
//
//  Created by 君の神様 on 16/2/22.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,WeiboSDKDelegate>
{
    NSString* wbtoken;
    NSString* wbCurrentUserID;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbRefreshToken;
@property (strong, nonatomic) NSString *wbCurrentUserID;
@end

