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
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
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

-(void)showDailyRecommandWithAvatarArray:(NSArray*)avatarArr{
    
    NSInteger count =avatarArr.count>self.headImageArray.count?self.headImageArray.count:avatarArr.count;
    for (int i = 0; i < count; ++i) {
        UIImageView *headImg = [self.headImageArray objectAtIndex:i];
        NSString *avaStr = [avatarArr objectAtIndex:i];
        KKImageViewWithUrlstring(headImg, avaStr, @"def_head");
    }
    
}

- (IBAction)tellThemBtnClick:(id)sender {

    UploadHeadImageViewController *headImage = KKViewControllerOfMainSB(@"UploadHeadImageViewController");
    [self.navigationController pushViewController:headImage animated:YES];
}
- (IBAction)changeBtnClick:(id)sender {
}

@end
