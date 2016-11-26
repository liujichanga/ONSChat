//
//  UploadHeadImageViewController.m
//  ONSChat
//
//  Created by 王磊 on 2016/11/25.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "UploadHeadImageViewController.h"
#import "DailyRecommandViewController.h"


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
    KKLog(@"跳过");
    [self nextAction];
}

-(void)nextAction
{
    if(KKSharedCurrentUser.dayFirst)
    {
        // 如果是今天第一次登陆，需要弹出每日推荐
        DailyRecommandViewController *dailyVC = KKViewControllerOfMainSB(@"DailyRecommandViewController");
        [self.navigationController pushViewController:dailyVC animated:YES];
    }
    else
    {
        //消失
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
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

    self.userHeadImageView.image = image;
    
    long long int timestamp = [NSDate date].timeIntervalSince1970 * 1000 + arc4random()%1000;
    NSString *imagename=KKStringWithFormat(@"%lld.jpg",timestamp);
    NSString *path = [CacheUserPath stringByAppendingPathComponent:imagename];
    
    NSData *imagedata=UIImageJPEGRepresentation(image, 0.75);
    
    BOOL result = [imagedata writeToFile:path atomically:path];
    
    if(result)
    {
        [KKSharedLocalPlistManager setKKValue:imagename forKey:Plist_Key_Avatar];
        KKSharedCurrentUser.avatarUrl=[CacheUserPath stringByAppendingPathComponent:imagename];
    }

    KKWEAKSELF
    [KKThredUtils runInMainQueue:^{
        [weakself nextAction];
    } delay:0.5];
}
@end
