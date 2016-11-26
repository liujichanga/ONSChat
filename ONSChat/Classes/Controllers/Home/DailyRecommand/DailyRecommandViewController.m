//
//  DailyRecommandViewController.m
//  ONSChat
//
//  Created by liujichang on 2016/11/23.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "DailyRecommandViewController.h"
#import "UploadHeadImageViewController.h"

@interface DailyRecommandViewController ()
//顶部文案
@property (weak, nonatomic) IBOutlet UILabel *topLabel;

//头像数组
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *headImageArray;

@end

@implementation DailyRecommandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *topStr = @"给大家%打个招呼%吧，你会结识很多新朋友哦！";
    NSMutableAttributedString *newTopStr;
    NSValue*rangValue;
    newTopStr = [topStr splitByPercent:&rangValue];
    self.topLabel.attributedText = newTopStr;
    
    [self loadDailyRecommandData];
    [self showDailyRecommandWithAvatarArray:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//请求数据
-(void)loadDailyRecommandData{
    [SVProgressHUD show];
    NSDictionary *param = @{@"limit":@(self.headImageArray.count)};
    [FSSharedNetWorkingManager GET:ServiceInterfaceDailyRecommand parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *respDic = (NSDictionary*)responseObject;
        KKLog(@"%@",respDic);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismissWithError:KKErrorInfo(error) afterDelay:1.2];
    }];
}

//取到头像 赋值
-(void)showDailyRecommandWithAvatarArray:(NSArray*)avatarArr{
    
    NSInteger count =avatarArr.count>self.headImageArray.count?self.headImageArray.count:avatarArr.count;
    for (int i = 0; i < count; ++i) {
        UIImageView *headImg = [self.headImageArray objectAtIndex:i];
        NSString *avaStr = [avatarArr objectAtIndex:i];
        KKImageViewWithUrlstring(headImg, avaStr, @"def_head");
    }
}
//告诉他们
- (IBAction)tellThemBtnClick:(id)sender {

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
//换一批
- (IBAction)changeBtnClick:(id)sender {
    KKLog(@"换一批");
    
    [self loadDailyRecommandData];
}

@end
