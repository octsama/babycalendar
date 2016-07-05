//
//  XXSHUDView.m
//  babycalendar
//
//  Created by 君の神様 on 16/4/9.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "XXSHUDView.h"
#import "SVProgressHUD.h"

@interface XXSHUDView ()

@property (nonatomic, copy)XXSHUDViewDismissBlock dismissBlock;

@end

@implementation XXSHUDView

+ (instancetype)sharedInstance {
    static XXSHUDView *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [XXSHUDView new];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
        [SVProgressHUD setRingThickness:4];
        [SVProgressHUD setCornerRadius:8];
        [SVProgressHUD setMinimumDismissTimeInterval:4];
    });
    
    return _sharedInstance;
}

+ (void)showLoading {
    [SVProgressHUD show];
}

+ (void)dismiss {
    [SVProgressHUD dismiss];
}

- (void)showWithStatus:(NSString *)string dismissBlock:(XXSHUDViewDismissBlock)block {
    [SVProgressHUD showWithStatus:string];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDDidDisappearNotification
                                               object:nil];
    _dismissBlock = block;
}

- (void)showInfoMessage:(NSString *)string dismissBlock:(XXSHUDViewDismissBlock)block {
    [SVProgressHUD showInfoWithStatus:string];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDDidDisappearNotification
                                               object:nil];
    _dismissBlock = block;
}

- (void)showSuccessMessage:(NSString *)string dismissBlock:(XXSHUDViewDismissBlock)block {
    [SVProgressHUD showSuccessWithStatus:string];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDDidDisappearNotification
                                               object:nil];
    _dismissBlock = block;
}

- (void)showErrorMessage:(NSString *)string dismissBlock:(XXSHUDViewDismissBlock)block {
    [SVProgressHUD showErrorWithStatus:string];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDDidDisappearNotification
                                               object:nil];
    _dismissBlock = block;
}

- (void)handleNotification:(NSNotification *)aNotification {
    if (_dismissBlock) {
        _dismissBlock();
    }
    _dismissBlock = nil;
}

@end
