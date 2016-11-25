//
//  UploadHeadImageViewController.m
//  ONSChat
//
//  Created by 王磊 on 2016/11/25.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "UploadHeadImageViewController.h"

@interface UploadHeadImageViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
//头像
@property (weak, nonatomic) IBOutlet UIImageView *userHeadImageView;

@end

@implementation UploadHeadImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.userHeadImageView.layer.cornerRadius = self.userHeadImageView.frame.size.width*0.5;
    self.userHeadImageView.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//拍照上传
- (IBAction)imageFromCamera:(id)sender {
    [self openImagePickerControllerWithScourceType:UIImagePickerControllerSourceTypeCamera];
}
//相册上传
- (IBAction)imageFromAlbum:(id)sender {
    [self openImagePickerControllerWithScourceType:UIImagePickerControllerSourceTypePhotoLibrary];

}
//跳过
- (IBAction)skipClick:(id)sender {
    
    
}

#pragma mark - UIImagePickerControllerDelegate
/** 打开照片选择器 */
- (void)openImagePickerControllerWithScourceType:(UIImagePickerControllerSourceType)sourceType {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setValue:@(UIStatusBarStyleLightContent) forKey:@"_previousStatusBarStyle"];
    picker.sourceType = sourceType;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


/** 获取到图片后进入这里 */
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // 关闭Picker
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 原图
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    }
    
    self.userHeadImageView.image = image;//[UIImage imageWithData:imageData];
}
@end
