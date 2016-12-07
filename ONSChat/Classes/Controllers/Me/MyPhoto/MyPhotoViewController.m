//
//  MyPhotoViewController.m
//  ONSChat
//
//  Created by liujichang on 2016/11/28.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "MyPhotoViewController.h"
#import "KKMediaPreviewController.h"

@interface MyPhotoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageView1WidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageView2WidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageView3WidthConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;


@end

@implementation MyPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _imageView1WidthConstraint.constant=(KKScreenWidth-120)/3.0;
    _imageView2WidthConstraint.constant=(KKScreenWidth-120)/3.0;
    _imageView3WidthConstraint.constant=(KKScreenWidth-120)/3.0;
    
    _imageView1.tag=0;
    _imageView2.tag=1;
    _imageView3.tag=2;
    
    UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
    [self.imageView1 addGestureRecognizer:tapGestureRecognizer1];
    
    UITapGestureRecognizer *tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
    [self.imageView2 addGestureRecognizer:tapGestureRecognizer2];
    
    UITapGestureRecognizer *tapGestureRecognizer3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
    [self.imageView3 addGestureRecognizer:tapGestureRecognizer3];


    [self loadImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)uploadClick:(id)sender {
    
    KKWEAKSELF;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"请选择" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakself openImagePickerControllerWithScourceType:UIImagePickerControllerSourceTypeCamera];
        
    }];
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakself openImagePickerControllerWithScourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:cameraAction];
    [alertController addAction:libraryAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
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
    
    
    NSString *photo1=[KKSharedLocalPlistManager kkValueForKey:Plist_Key_Photo1];
    NSString *photo2=[KKSharedLocalPlistManager kkValueForKey:Plist_Key_Photo2];
    NSString *photo3=[KKSharedLocalPlistManager kkValueForKey:Plist_Key_Photo3];
   
    if(KKStringIsNotBlank(photo1)&&KKStringIsNotBlank(photo2)&&KKStringIsNotBlank(photo3))
    {
        [MBProgressHUD showMessag:@"不能再上传了" toView:self.view];
        return;
    }
    
    // 原图
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    long long int timestamp = [NSDate date].timeIntervalSince1970 * 1000 + arc4random()%1000;
    NSString *imagename=KKStringWithFormat(@"%lld.jpg",timestamp);
    NSString *path = [CacheUserPath stringByAppendingPathComponent:imagename];
    
    NSData *imagedata=UIImageJPEGRepresentation(image, 0.75);
    
    BOOL result = [imagedata writeToFile:path atomically:YES];
    
    if(result)
    {
        if(KKStringIsBlank(photo1))
        {
            [KKSharedLocalPlistManager setKKValue:imagename forKey:Plist_Key_Photo1];
        }
        else if(KKStringIsBlank(photo2))
        {
            [KKSharedLocalPlistManager setKKValue:imagename forKey:Plist_Key_Photo2];
        }
        else if(KKStringIsBlank(photo3))
        {
            [KKSharedLocalPlistManager setKKValue:imagename forKey:Plist_Key_Photo3];
        }
        
        [MBProgressHUD showMessag:@"上传审核中" toView:self.view];
        
        [self loadImage];
    }
    
}

-(void)loadImage
{
    NSString *photo1=[KKSharedLocalPlistManager kkValueForKey:Plist_Key_Photo1];
    NSString *photo2=[KKSharedLocalPlistManager kkValueForKey:Plist_Key_Photo2];
    NSString *photo3=[KKSharedLocalPlistManager kkValueForKey:Plist_Key_Photo3];

    if(KKStringIsNotBlank(photo1))
    {
        _imageView1.image=[UIImage imageWithContentsOfFile:[CacheUserPath stringByAppendingPathComponent:photo1]];
    }
    if(KKStringIsNotBlank(photo2))
    {
        _imageView2.image=[UIImage imageWithContentsOfFile:[CacheUserPath stringByAppendingPathComponent:photo2]];

    }
    if(KKStringIsNotBlank(photo3))
    {
        _imageView3.image=[UIImage imageWithContentsOfFile:[CacheUserPath stringByAppendingPathComponent:photo3]];

    }
    
}

-(void)tapImageView:(UITapGestureRecognizer*)tapGestureRecognizer{
    
    NSInteger index=tapGestureRecognizer.view.tag;
    
    NSMutableArray *mediasArray=[NSMutableArray array];
    
    NSString *photo1=[KKSharedLocalPlistManager kkValueForKey:Plist_Key_Photo1];
    NSString *photo2=[KKSharedLocalPlistManager kkValueForKey:Plist_Key_Photo2];
    NSString *photo3=[KKSharedLocalPlistManager kkValueForKey:Plist_Key_Photo3];
    if(KKStringIsNotBlank(photo1))
    {
        UIImage *image=[UIImage imageWithContentsOfFile:[CacheUserPath stringByAppendingPathComponent:photo1]];
        KKMedia *media=[KKMedia mediaThumbnail:image url:nil type:KKMediaTypeImage];
        [mediasArray addObject:media];
    }
    if(KKStringIsNotBlank(photo2))
    {
        UIImage *image=[UIImage imageWithContentsOfFile:[CacheUserPath stringByAppendingPathComponent:photo2]];
        KKMedia *media=[KKMedia mediaThumbnail:image url:nil type:KKMediaTypeImage];
        [mediasArray addObject:media];
    }
    if(KKStringIsNotBlank(photo3))
    {
        UIImage *image=[UIImage imageWithContentsOfFile:[CacheUserPath stringByAppendingPathComponent:photo3]];
        KKMedia *media=[KKMedia mediaThumbnail:image url:nil type:KKMediaTypeImage];
        [mediasArray addObject:media];
    }
    
    KKMediaPreviewController *vc = [[KKMediaPreviewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey : @(16)}];
    vc.medias = mediasArray;
    vc.startIndex = index;
    
    [self.navigationController pushViewController:vc animated:YES];

    
}

@end
