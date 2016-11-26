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
//uid 打招呼使用
@property (nonatomic, strong) NSString *uidStr;
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
    self.navigationItem.hidesBackButton = YES;
    [self loadDailyRecommandData];
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
        KKLog(@"daily %@",respDic);
        if (respDic&&respDic.count>0) {
            [SVProgressHUD dismiss];
            NSArray *aaData = [respDic objectForKey:@"aaData"];
            if (aaData.count>0) {
                //保存头像url
                NSMutableArray *avaStrArr = [NSMutableArray array];
                //拼接uid
                NSString *uidStr;
                for (NSDictionary *dic in aaData) {
                    NSString *avaStr = [dic stringForKey:@"avatar" defaultValue:@""];
                    NSString *uid = [dic stringForKey:@"id" defaultValue:@""];
                    [avaStrArr addObject:avaStr];
                    if (uidStr.length==0) {
                        uidStr =uid;
                    }else{
                        uidStr = [uidStr stringByAppendingString:[NSString stringWithFormat:@",%@",uid]];
                    }
                }
                self.uidStr = uidStr;
                [self showDailyRecommandWithAvatarArray:avaStrArr];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismissWithError:KKErrorInfo(error) afterDelay:1.2];
    }];
}

//取到头像 赋值
-(void)showDailyRecommandWithAvatarArray:(NSMutableArray*)avatarArr{
    
    NSInteger count =avatarArr.count>self.headImageArray.count?self.headImageArray.count:avatarArr.count;
    for (int i = 0; i < count; ++i) {
        UIImageView *headImg = [self.headImageArray objectAtIndex:i];
        NSString *avaStr = [avatarArr objectAtIndex:i];
        KKImageViewWithUrlstring(headImg, avaStr, @"def_head");
    }
}
//告诉他们
- (IBAction)tellThemBtnClick:(id)sender {
    NSDictionary *param = @{@"uid":self.uidStr};
    [FSSharedNetWorkingManager POST:ServiceInterfaceGreet parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *respDic = (NSDictionary*)responseObject;
        KKLog(@"greet %@",respDic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
//换一批
- (IBAction)changeBtnClick:(id)sender {
    KKLog(@"换一批");
    
    [self loadDailyRecommandData];
}

@end
