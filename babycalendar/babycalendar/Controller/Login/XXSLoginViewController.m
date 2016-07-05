//
//  XXSLoginViewController.m
//  babycalendar
//
//  Created by 君の神様 on 16/4/9.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "XXSLoginViewController.h"
#import "XXSTabViewController.h"
#import "XXSHUDView.h"
#import "XXSTools.h"
#import "XXSConfig.h"

@interface XXSLoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation XXSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.loginButton.layer.masksToBounds = YES;
    self.loginButton.layer.cornerRadius = 3.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)loginButtonClicked:(UIButton *)sender {
    NSString *nameString = self.userNameTextField.text;
    NSString *passwordString = self.passwordTextField.text;
    if ([nameString length] < 4 || passwordString.length < 4) {
        [[XXSHUDView sharedInstance] showErrorMessage:NSLocalizedString(@"帐号或密码长度不正确", nil)  dismissBlock:nil];
        return;
    }
    [_loginButton setTitle:NSLocalizedString(@"登录中...", nil) forState:UIControlStateNormal];
    if ([nameString isEqualToString:@"admin"] &&
        [passwordString isEqualToString:@"admin"]) {
        [XXSConfig sharedConfig].userToken = @"admin";
        XXSTabViewController *tabViewController = [[XXSTabViewController alloc] init];
        [UIApplication sharedApplication].delegate.window.rootViewController = tabViewController;
    } else {
        [[XXSHUDView sharedInstance] showErrorMessage:NSLocalizedString(@"帐号或密码不正确", nil)  dismissBlock:nil];
        [_loginButton setTitle:NSLocalizedString(@"登录", nil) forState:UIControlStateNormal];
        return;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.userNameTextField) {
        [self.passwordTextField becomeFirstResponder];
        return YES;
    }
    if (textField == self.passwordTextField) {
        [self.passwordTextField resignFirstResponder];
        return YES;
    }
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
}

@end
