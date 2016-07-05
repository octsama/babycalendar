//
//  XXSDetailViewController.m
//  babycalendar
//
//  Created by 君の神様 on 16/5/10.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "XXSDetailViewController.h"
#import "XXSActivityData.h"
#import "WeiboSDK.h"
#import "AppDelegate.h"
#import "XXSDBManager.h"
#import "XXSHUDView.h"

@interface XXSDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *babyImage;
@property (weak, nonatomic) IBOutlet UILabel *babyNote;
@property (weak, nonatomic) IBOutlet UILabel *userNameAndTime;
@property (nonatomic, strong) XXSActivityData *data;

@end

@implementation XXSDetailViewController

- (instancetype)initWithData:(XXSActivityData *)data {
    self = [super init];
    if (self) {
        self.data = data;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.babyNote.text = self.data.behavior;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    NSString *str = [NSString stringWithFormat:@"%ld",self.data.createdTime];
    NSTimeInterval time = [str doubleValue];
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *date = [formatter stringFromDate:detailDate];
    self.userNameAndTime.text = [NSString stringWithFormat:@"admin，%@",date];
    // Do any additional setup after loading the view from its nib.
    self.babyImage.image = [UIImage imageWithData:self.data.photo];
//    [self.babyImage setImage:[UIImage imageWithData:self.data.photo]];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(deleteData)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"moreIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(moreAction)];
}

- (void)moreAction {
//    [self.navigationController popViewControllerAnimated:YES];
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        [self dismissViewControllerAnimated:YES completion:nil];
        [[XXSDBManager dbManager] deleteFromTableWithModel:self.data];
        [[XXSHUDView sharedInstance] showSuccessMessage:@"已删除" dismissBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
    UIAlertAction *shareWeiboAction = [UIAlertAction actionWithTitle:@"分享到微博" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
        authRequest.redirectURI = kRedirectURL;
        authRequest.scope = @"all";
        
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:authRequest access_token:myDelegate.wbtoken];
        request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                             @"Other_Info_1": [NSNumber numberWithInt:123],
                             @"Other_Info_2": @[@"obj1", @"obj2"],
                             @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
        //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
        [WeiboSDK sendRequest:request];

    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [actionSheet addAction:deleteAction];
    [actionSheet addAction:shareWeiboAction];
    [actionSheet addAction:cancelAction];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (WBMessageObject *)messageToShare {
    WBMessageObject *message = [WBMessageObject message];
    message.text = [NSString stringWithFormat:@"%@",self.data.behavior];
    WBImageObject *image = [WBImageObject object];
    image.imageData = self.data.photo;
//     image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_1" ofType:@"jpg"]];
    message.imageObject = image;
    return message;
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
