//
//  XXSTabViewController.m
//  babycalendar
//
//  Created by 君の神様 on 16/2/24.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "XXSTabViewController.h"
#import "XXSMainViewController.h"
#import "XXSSettingViewController.h"

@interface XXSTabViewController ()<UINavigationControllerDelegate>

@property (nonatomic, strong)XXSMainViewController *mainViewController;
@property (nonatomic, strong)XXSSettingViewController *settingViewController;

@end

@implementation XXSTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prefersStatusBarHidden];
    _mainViewController = [[XXSMainViewController alloc] init];
    UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:_mainViewController];
    _settingViewController = [[XXSSettingViewController alloc] init];
    UINavigationController *setingNav = [[UINavigationController alloc] initWithRootViewController:_settingViewController];
    mainNav.delegate = self;
    self.viewControllers = @[mainNav,setingNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
