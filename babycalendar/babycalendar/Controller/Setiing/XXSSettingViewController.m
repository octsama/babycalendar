//
//  XXSSettingViewController.m
//  babycalendar
//
//  Created by 君の神様 on 16/2/24.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "XXSSettingViewController.h"
#import <MessageUI/MessageUI.h>
#import "XXSHUDView.h"
#import "XXSConfig.h"
#import "XXSLoginViewController.h"

@interface XXSSettingViewController () <UITableViewDataSource, UITableViewDelegate,MFMessageComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *settingView;
@property (nonatomic, strong) NSArray *settingsArray;
@property (nonatomic, strong) UISwitch *networkSwitch;

@end

static NSString *mSettingsCellIdentifier = @"settingCell";
static NSString *mSettingsDetailCellIdentifier = @"settingsDetailCell";

@implementation XXSSettingViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"设置" image:[UIImage imageNamed:@"settingIcon"] selectedImage:[UIImage imageNamed:@"settingIcon"]];
    }
    return self;
}

- (NSArray *)settingsArray {
    if (!_settingsArray) {
        _settingsArray = @[NSLocalizedString(@"新消息通知", nil),
                           NSLocalizedString(@"非Wi-Fi下图片可以下载", nil),
                           NSLocalizedString(@"关于", nil),
                           NSLocalizedString(@"邀请", nil),
                           NSLocalizedString(@"退出登录", nil)];
    }
    return _settingsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.settingView registerClass:[UITableViewCell class] forCellReuseIdentifier:mSettingsCellIdentifier];
    _networkSwitch = [[UISwitch alloc] init];
    [_networkSwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    self.title = @"设置";
    // Do any additional setup after loading the view from its nib.
}

- (void)changeSwitch:(UISwitch *)sender {
//    [ESConfig sharedConfig].chooseNetwork = [NSString stringWithFormat:@"%i", _networkSwitch.isOn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _networkSwitch.on = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.settingsArray count] - 1;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mSettingsCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 1) {
        cell.textLabel.text = [_settingsArray lastObject];
    } else {
        cell.textLabel.text = _settingsArray[indexPath.row];
    }
    cell.textLabel.textColor = [UIColor blackColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    if (indexPath.row == 1) {
        cell.accessoryView = _networkSwitch;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 3) {
        if ([MFMessageComposeViewController canSendText]) {
            MFMessageComposeViewController *messageVC = [[MFMessageComposeViewController alloc] init];
//            messageVC.recipients = 这边填写要发送的短信好伐的数组;
            messageVC.body = @"快来跟我一起分享宝宝的一切吧";
            messageVC.messageComposeDelegate = self; //指定代理
            [self presentViewController:messageVC animated:YES completion:nil];
        } else {
//            [PublicModel showHUDWithInfo:self andInfo:@"设备不支持短信功能"];
            [[XXSHUDView sharedInstance] showErrorMessage:@"设备不支持短信功能" dismissBlock:nil];
        }
    } else if (indexPath.section == 1) {
        [XXSConfig sharedConfig].userToken = nil;
        XXSLoginViewController *loginView = [[XXSLoginViewController alloc] init];
        [self presentViewController:loginView animated:YES completion:nil];
    }
}

#pragma mark MFmessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    if (result == MessageComposeResultCancelled) {
        [controller dismissViewControllerAnimated:YES completion:nil];
    } else if (result == MessageComposeResultFailed) {
        [controller dismissViewControllerAnimated:YES completion:^{
            // [PublicModel showHUDWithInfo:self andInfo:@"发送失败"];
        }];
    } else {
        [controller dismissViewControllerAnimated:YES completion:^{
            // [PublicModel showHUDWithInfo:self andInfo:@"发送成功"];
        }];
    }
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
