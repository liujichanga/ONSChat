//
//  NewDynamicViewController.m
//  ONSChat
//
//  Created by 王磊 on 2016/12/1.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "NewDynamicViewController.h"

#import "VideoListViewController.h"

@interface NewDynamicViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
//文字输入
@property (weak, nonatomic) IBOutlet UITextField *dyTextField;
//添加媒体按钮
@property (weak, nonatomic) IBOutlet UIButton *dyAddImageBtn;
//视频或图片 url
@property (nonatomic, strong) NSString *dynamicURL;
//视频缩略图URL 图片为空
@property (nonatomic, strong) NSString *dynamiVideoThumbnail;
//媒体类型
@property(assign,nonatomic) KKDynamicsType dynamicsType;

@end

@implementation NewDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem=rightItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//添加图片
- (IBAction)dyAddImageBtnClick:(id)sender {
    
    [self.dyTextField resignFirstResponder];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"拍照", @"从相册选择",@"视频", nil];
    [sheet showInView:self.view];
    
}


#pragma mark - Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        [self openImagePickerControllerWithScourceType:UIImagePickerControllerSourceTypeCamera];
        self.dynamicsType =KKDynamicsTypeImage;
    } else if (buttonIndex == 1) {
        [self openImagePickerControllerWithScourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        self.dynamicsType =KKDynamicsTypeImage;
    }else if (buttonIndex == 2){        
        [self showVideoList];
        self.dynamicsType =KKDynamicsTypeVideo;
    }
}

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

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // 关闭Picker
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 原图
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    }
    [self.dyAddImageBtn setImage:image forState:UIControlStateNormal];

    //创建文件名
    long long int timestamp = [NSDate date].timeIntervalSince1970 * 1000 + arc4random()%1000;
    NSString *imagename=KKStringWithFormat(@"%lld.jpg",timestamp);
    //补齐路径
    NSString *path = [CacheUserPath stringByAppendingPathComponent:imagename];
    
    NSData *imagedata=UIImageJPEGRepresentation(image, 0.75);
    
    BOOL result = [imagedata writeToFile:path atomically:path];
    
    if(result)
    {
        self.dynamicURL=path;
    }
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 私有方法
//发布动态
-(void)rightItemClick{
    
    if (KKStringIsBlank(self.dyTextField.text)){
        [MBProgressHUD showMessag:@"请输入发布内容" toView:nil];
        return;
    }else if (KKStringIsBlank(self.dynamicURL)) {
        [MBProgressHUD showMessag:@"请选择图片或视频" toView:nil];
        return;
    }
    
    KKWEAKSELF
    //创建动态数据模型
    KKDynamic *dy = [self addDynamic];
    //写入数据库
    [KKSharedDynamicDao addDynamic:dy completion:^(BOOL success) {
        KKLog(@"add %zd",success);
        if (success) {
            [KKNotificationCenter postNotificationName:@"updateList" object:nil];
            [weakself.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showMessag:@"发布失败" toView:nil];
        }
    } inBackground:YES];
}

//创建本地动态模型
-(KKDynamic*)addDynamic{
    
    KKDynamic *dynamic=[[KKDynamic alloc] init];
    dynamic.praiseNum=0;
    dynamic.commentNum=0;
    dynamic.dynamicsType = self.dynamicsType;
    dynamic.dynamicUrl = self.dynamicURL;
    dynamic.dynamicText = self.dyTextField.text;
    dynamic.dynamiVideoThumbnail = self.dynamiVideoThumbnail.length>0?self.dynamiVideoThumbnail:@"";
    //随机一个最近两天的日期
    int value = arc4random() % (2);
    if(value==0)
    {
        dynamic.date=[[[NSDate date] dateBySubtractingDays:1] stringWithFormat:@"MM月dd日"];
    }
    else
    {
        dynamic.date=[[[NSDate date] dateBySubtractingDays:2] stringWithFormat:@"MM月dd日"];
    }
    return dynamic;
}

//显示本地视频列表
-(void)showVideoList{
    
    KKWEAKSELF
    VideoListViewController *videoList = KKViewControllerOfMainSB(@"VideoListViewController");
    videoList.selectBlock = ^(PHAsset *asset){
        [weakself selectVideo:asset];
    };
    UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:videoList];
    [self presentViewController:navController animated:YES completion:nil];
}

//处理所选视频
-(void)selectVideo:(PHAsset*)asset{
    KKWEAKSELF
    PHImageManager *imgManager = [PHImageManager defaultManager];
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc]init];
    PHImageRequestOptions *imgOp = [[PHImageRequestOptions alloc]init];
    //获取视频缩略图
    [imgManager requestImageForAsset:asset targetSize:CGSizeMake(80, 80) contentMode:PHImageContentModeAspectFill options:imgOp resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        UIImage *img = (UIImage*)result;
        [weakself.dyAddImageBtn setImage:[UIImage imageNamed:@"jc_play_normal"] forState:UIControlStateNormal];
        [weakself.dyAddImageBtn setBackgroundImage:img forState:UIControlStateNormal];
        
        long long int timestamp = [NSDate date].timeIntervalSince1970 * 1000 + arc4random()%1000;
        NSString *imagename=KKStringWithFormat(@"%lld.jpg",timestamp);
        NSString *path = [CacheUserPath stringByAppendingPathComponent:imagename];
        
        NSData *imagedata=UIImageJPEGRepresentation(img, 0.75);
        BOOL writeResult = [imagedata writeToFile:path atomically:path];
        if(writeResult)
        {
            weakself.dynamiVideoThumbnail=path;
        }
    }];
    //获取视频
    [imgManager requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        KKLog(@"%@",asset);
        AVURLAsset *videoAsset = (AVURLAsset*)asset;
        
        long long int timestamp = [NSDate date].timeIntervalSince1970 * 1000 + arc4random()%1000;
        NSString *imagename=KKStringWithFormat(@"%lld.mp4",timestamp);
        NSString *path = [CacheUserPath stringByAppendingPathComponent:imagename];
        
        NSURL *videoURL = videoAsset.URL;
        NSData *videoData = [NSData dataWithContentsOfURL:videoURL];

        BOOL result = [videoData writeToFile:path atomically:path];
        
        if(result)
        {
            weakself.dynamicURL=path;
        }
    }];
}
@end
