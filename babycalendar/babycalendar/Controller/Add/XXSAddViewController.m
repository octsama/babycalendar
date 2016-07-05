//
//  XXSAddViewController.m
//  babycalendar
//
//  Created by 君の神様 on 16/4/4.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "XXSAddViewController.h"
#import "XXSImageBrowser.h"
#import "XXSActivityData.h"
#import "XXSDBManager.h"
#import "XXSHUDView.h"

@interface XXSAddViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *babyNote;
@property (weak, nonatomic) IBOutlet UIImageView *babyImage;

@end

@implementation XXSAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"记录";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissController)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takePhoto)];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage)];
//    [self.babyImage addGestureRecognizer:tap];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard {
    [self.babyNote resignFirstResponder];
}

- (void)magnifyImage
{
//    [XXSImageBrowser showImage:self.babyImage];//调用方法
}

- (void)dismissController {
    [self.babyNote resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)saveDataButtonClicked:(UIButton *)sender {
    NSData *imageData = UIImagePNGRepresentation(self.babyImage.image);
    XXSActivityData *data = [[XXSActivityData alloc] init];
    data.photo = imageData;
    data.behavior = self.babyNote.text;
    data.userId = 1;
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setTimeZone:[NSTimeZone defaultTimeZone]];
    NSInteger createdTime = [[NSDate date] timeIntervalSince1970];
    data.createdTime = createdTime;
    [[XXSDBManager dbManager] insertActivityTableWithModel:data];
    [[XXSHUDView sharedInstance] showSuccessMessage:@"保存成功" dismissBlock:^{
        [self dismissController];
    }];
}

- (void)takePhoto {
    UIAlertController *photoSheet = [UIAlertController alertControllerWithTitle:nil
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
    }];
    UIAlertAction *pickPhontAction = [UIAlertAction actionWithTitle:@"从相册选择"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *_Nonnull action) {
                                                                UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
                                                                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                                                                    pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                                    pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
                                                                }
                                                                pickerImage.delegate = self;
                                                                pickerImage.allowsEditing = NO;
                                                                [self presentViewController:pickerImage animated:YES completion:nil];
                                                            }];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        imagePicker.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    [photoSheet addAction:pickPhontAction];
    [photoSheet addAction:cameraAction];
    [photoSheet addAction:cancleAction];
    [self presentViewController:photoSheet animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName {
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 1.0);
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPath atomically:NO];
}

#pragma mark -UIImagePickerControllerDelegate

// 选择图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
//    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self saveImage:image withName:@"avatar.png"];
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"avatar.png"];
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    [self.babyImage setImage:savedImage];
//    //当选择的类型是图片
//    if ([type isEqualToString:@"public.image"])
//    {
//        //先把图片转成NSData
//        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//        NSData *data;
//        if (UIImagePNGRepresentation(image) ==nil)
//        {
//            data = UIImageJPEGRepresentation(image,1.0);
//        }
//        else
//        {
//            data = UIImagePNGRepresentation(image);
//        }
//        
//        //图片保存的路径
//        //这里将图片放在沙盒的documents文件夹中
//        NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//        
//        //文件管理器
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        
//        //把刚刚图片转换的data对象拷贝至沙盒中并保存为image.png
//        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
//        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/userHeader.png"] contents:data attributes:nil];
    
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        //加在视图中
//        [self.mineView.headerButton setBackgroundImage:image forState:(UIControlStateNormal)];
        
//    }
}

// 取消选取图片
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
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
