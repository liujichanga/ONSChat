//
//  NewDynamicViewController.m
//  ONSChat
//
//  Created by 王磊 on 2016/12/1.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "NewDynamicViewController.h"

@interface NewDynamicViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *dyTextField;
@property (weak, nonatomic) IBOutlet UIButton *dyAddImageBtn;
@property (nonatomic, strong) NSString *dynamicURL;
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
//发布动态
-(void)rightItemClick{
    if (KKStringIsBlank(self.dynamicURL)) {
        
        [MBProgressHUD showMessag:@"请添加图片" toView:nil];
        return;
    }
    KKWEAKSELF
    KKDynamic *dy = [self addDynamic];
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

-(KKDynamic*)addDynamic{
    
    KKDynamic *dynamic=[[KKDynamic alloc] init];
    dynamic.praiseNum=0;
    dynamic.commentNum=0;
    dynamic.dynamicsType = self.dynamicsType;
    dynamic.dynamicUrl = self.dynamicURL;
    dynamic.dynamicText = self.dyTextField.text;
    dynamic.dynamiVideoThumbnail = @"";
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

#pragma mark - Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        [self openImagePickerControllerWithScourceType:UIImagePickerControllerSourceTypeCamera];
        self.dynamicsType =KKDynamicsTypeImage;
    } else if (buttonIndex == 1) {
        [self openImagePickerControllerWithScourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        self.dynamicsType =KKDynamicsTypeImage;
    }else if (buttonIndex == 2){
        
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

    long long int timestamp = [NSDate date].timeIntervalSince1970 * 1000 + arc4random()%1000;
    NSString *imagename=KKStringWithFormat(@"%lld.jpg",timestamp);
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
@end
