//
//  UserHobbyViewController.m
//  ONSChat
//
//  Created by 王磊 on 2016/11/23.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "UserHobbyViewController.h"

@interface UserHobbyViewController ()
//兴趣标签
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *hobbyArray;
//兴趣文案(最多9个)
@property (nonatomic, strong) NSArray *hobbyStrArray;
@end

@implementation UserHobbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    //请求数据后 替换内容
    self.hobbyStrArray = @[@"丝袜撩人",@"污段子小能手",@"小护士求交往",@"唱歌给你听",@"潮人啪啪拍",@"文爱勾魂",@"迷人小妖精",@"挡不住的波涛汹涌",@"爱秀长腿MM"];
    [self subviewsUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)subviewsUI{
    for (int i = 0; i < self.hobbyArray.count; ++i) {
        UIButton *btn = [self.hobbyArray objectAtIndex:i];
        [btn.layer setMasksToBounds:YES];
        [btn.layer setCornerRadius:3.0];
        [btn.layer setBorderWidth:1.0];
        [btn.layer setBorderColor:[UIColor blackColor].CGColor];
        NSString *title = [NSString stringWithFormat:@" %@ ",self.hobbyStrArray[i]];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithColor:KKColorPurple forSize:btn.frame.size radius:0 borderWidth:1 borderColor:nil] forState:UIControlStateSelected];
    }
}

- (IBAction)hobbyBtnClick:(UIButton*)sender {
    sender.selected = !sender.selected;
    if (sender.selected==YES) {
        [sender.layer setBorderColor:KKColorPurple.CGColor];
    }else{
        [sender.layer setBorderColor:[UIColor blackColor].CGColor];
    }

}

- (IBAction)finishBtnClick:(id)sender {
    NSString *hobbyStr;
    for (UIButton* btn in self.hobbyArray) {
        if (btn.selected==YES) {
            if (hobbyStr.length==0) {
                hobbyStr =btn.titleLabel.text;
            }else{
                hobbyStr = [hobbyStr stringByAppendingString:[NSString stringWithFormat:@",%@",btn.titleLabel.text]];
            }
        }
    }
    if (hobbyStr.length==0) {
        [MBProgressHUD showMessag:@"请选择兴趣爱好" toView:nil];
        return;
    }else{
        hobbyStr = [hobbyStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    KKLog(@"%@",hobbyStr);
    KKSharedUserManager.tempUser.hobby = hobbyStr;
    
    NSDictionary *params=@{@"gender":@(KKSharedUserManager.tempUser.sex),@"nickname":KKSharedUserManager.tempUser.nickName,@"channel":ChannelId,@"age":@(KKSharedUserManager.tempUser.age),@"address":KKSharedUserManager.tempUser.address,@"hobby":KKSharedUserManager.tempUser.hobby};
    
    [SVProgressHUD show];
    //注册
    [FSSharedNetWorkingManager POST:ServiceInterfaceRegister parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = (NSDictionary*)responseObject;
        KKLog(@"register:%@",responseObject);
        BOOL status=[dic boolForKey:@"status" defaultValue:NO];
        if(status)
        {
            KKSharedUserManager.tempUser.userId=[dic longlongForKey:@"id" defaultValue:0];
            KKSharedUserManager.tempUser.password=[dic stringForKey:@"password" defaultValue:@""];
            
            //执行登录
            NSDictionary *para=@{@"loginname":@(KKSharedUserManager.tempUser.userId),@"password":KKSharedUserManager.tempUser.password,@"channel":ChannelId};
            [FSSharedNetWorkingManager POST:ServiceInterfaceLogin parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSDictionary *loginDic = (NSDictionary*)responseObject;
                KKLog(@"login:%@",loginDic);
                BOOL status1=[loginDic boolForKey:@"status" defaultValue:NO];
                if(status1)
                {
                    [SVProgressHUD dismiss];
                    
                    KKSharedUserManager.currentUser=KKSharedUserManager.tempUser;
                    
                    [KKAppDelegate loginSucceed:loginDic];
                }
                else
                {
                    [SVProgressHUD dismissWithError:[loginDic stringForKey:@"statusMsg" defaultValue:@"登录失败"] afterDelay:2.0];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [SVProgressHUD dismissWithError:KKErrorInfo(error) afterDelay:2.0];
            }];
        }
        else
        {
            [SVProgressHUD dismissWithError:[dic stringForKey:@"statusMsg" defaultValue:@"注册失败"] afterDelay:2.0];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismissWithError:KKErrorInfo(error) afterDelay:2.0];
    }];
}

@end
