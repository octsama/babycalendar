//
//  XXSHUDView.h
//  babycalendar
//
//  Created by 君の神様 on 16/4/9.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^XXSHUDViewDismissBlock)();

@interface XXSHUDView : NSObject

+ (instancetype)sharedInstance;
+ (void)dismiss;
+ (void)showLoading;
- (void)showWithStatus:(NSString *)string dismissBlock:(XXSHUDViewDismissBlock)block;
- (void)showInfoMessage:(NSString *)string dismissBlock:(XXSHUDViewDismissBlock)block;
- (void)showSuccessMessage:(NSString *)string dismissBlock:(XXSHUDViewDismissBlock)block;
- (void)showErrorMessage:(NSString *)string dismissBlock:(XXSHUDViewDismissBlock)block;

@end
