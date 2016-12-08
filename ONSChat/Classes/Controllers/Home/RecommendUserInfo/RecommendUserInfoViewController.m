//
//  RecommendUserInfoViewController.m
//  ONSChat
//
//  Created by 王磊 on 2016/11/26.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "RecommendUserInfoViewController.h"
#import "DynamicListViewController.h"
#import "BaseInfoCell.h"
#import "SignCell.h"
#import "ContactWayCell.h"
#import "CarouselCell.h"
#import "VideoCell.h"
#import "ChatViewController.h"


#define cellVideolIdentifier @"VideoCell"
#define cellBaseInfoIdentifier @"BaseInfoCell"
#define cellSignIdentifier @"SignCell"
#define cellContactWayIdentifier @"ContactWayCell"
#define cellCarouselIdentifier @"CarouselCell"

@interface RecommendUserInfoViewController ()<UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//选项
@property (nonatomic, strong) NSArray *baseInfoQ1;
@property (nonatomic, strong) NSArray *baseInfoQ2;
@property (nonatomic, strong) NSArray *TABaseInfoQ;
//答案
@property (nonatomic, strong) NSArray *baseInfoA1;
@property (nonatomic, strong) NSArray *baseInfoA2;
@property (nonatomic, strong) NSArray *TABaseInfoA;
//内心独白高度
@property (nonatomic, assign) CGFloat signHeight;
//联系方式
@property (nonatomic, strong) NSArray *contactWayArr;
//打招呼按钮 
@property (nonatomic, strong) ONSButtonPurple *noticeBtn;
//视频cell高度
@property (nonatomic, assign) CGFloat videoHeight;
//视频数据
@property (nonatomic, strong) NSDictionary *videoDic;
//user
@property(strong,nonatomic) KKUser *currentUser;
//是否有过对话
@property (nonatomic, assign) BOOL hasConversation;
@end

@implementation RecommendUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.baseInfoQ1 = @[@"职业",@"收入",@"血型",@"体重",@"星座",@"婚姻状况",@"是否有房",@"是否有车"];
    self.baseInfoQ2 = @[@"魅力部位",@"喜欢的异性类型",@"是否接受异地恋",@"是否要小孩",@"是否接受婚前性行为",@"是否愿意婚后与父母同住",@"兴趣爱好",@"个性特征"];
    self.TABaseInfoQ = @[@"居住地",@"年龄范围",@"收入",@"身高",@"最低学历"];
    self.contactWayArr = @[@"QQ号码********",@"手机号码********",@"微信号码********"];
    self.baseInfoA1 = [NSArray array];
    self.baseInfoA2 = [NSArray array];
    self.TABaseInfoA = [NSArray array];
 
    [self.tableView registerNib:[UINib nibWithNibName:cellBaseInfoIdentifier bundle:nil] forCellReuseIdentifier:cellBaseInfoIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:cellSignIdentifier bundle:nil] forCellReuseIdentifier:cellSignIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:cellContactWayIdentifier bundle:nil] forCellReuseIdentifier:cellContactWayIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:cellCarouselIdentifier bundle:nil] forCellReuseIdentifier:cellCarouselIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:cellVideolIdentifier bundle:nil] forCellReuseIdentifier:cellVideolIdentifier];
    //举报功能
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    if (self.dynamicsID.length>0) {
        [self loadVideoData];
    }
    [self loadInfoData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    //先判断是否有过对话
    [ONSSharedConversationDao getConversationByTargetId:self.uid completion:^(id result) {
        if (result) {
            if (self.noticeBtn) {
                [self.noticeBtn removeFromSuperview];
            }
            ONSButtonPurple *btn = [ONSButtonPurple ONSButtonWithTitle:@"去聊天" frame:CGRectMake(0, KKScreenHeight-50, KKScreenWidth, 50)];
            btn.layer.cornerRadius = 0;
            [btn addTarget:self action:@selector(noticeBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btn];
            [self.view bringSubviewToFront:btn];
            self.noticeBtn = btn;
            self.hasConversation = YES;
        }
    } inBackground:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//请求基本信息数据
-(void)loadInfoData{
    [SVProgressHUD show];
    NSDictionary *param = @{@"uid":self.uid};
    [FSSharedNetWorkingManager GET:ServiceInterfaceUserInfo parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *respDic = (NSDictionary*)responseObject;
        KKLog(@"资料 %@",respDic);
        if (respDic&&respDic.count>0) {
            [SVProgressHUD dismiss];
            
            KKUser *user = [[KKUser alloc]initWithDicFull:respDic];
            self.currentUser=user;
            
            NSString *hasCar;
            if (user.hasCar==YES) {
                hasCar =@"是";
            }else{
                hasCar = @"否";
            }
            self.baseInfoA1 = [NSArray arrayWithObjects:user.job,user.income,user.blood,[NSString stringWithFormat:@"%ldkg",(long)user.weight],user.astro,user.marry,user.hasHouse,hasCar,nil];
            self.baseInfoA2 = [NSArray arrayWithObjects:user.pos,user.lovetype,user.distanceLove,user.child,user.livetog,user.withparent,user.hobby,user.personality, nil];
            self.TABaseInfoA = [NSArray arrayWithObjects:user.ta_address,user.ta_age,user.ta_income,user.ta_height,user.ta_graduate,nil];
            
            self.title =user.nickName;
            if (!self.noticeBtn) {
                //如果已打过招呼
                if (user.noticedToday == YES) {
                    
                    ONSButtonPurple *btn = [ONSButtonPurple ONSButtonWithTitle:@"已打招呼，去聊天" frame:CGRectMake(0, KKScreenHeight-50, KKScreenWidth, 50)];
                    btn.layer.cornerRadius = 0;
                    [btn addTarget:self action:@selector(noticeBtnClick) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:btn];
                    [self.view bringSubviewToFront:btn];
                    self.noticeBtn = btn;
                }
                //没打过招呼
                else{
                    ONSButtonPurple *btn = [ONSButtonPurple ONSButtonWithTitle:@"打招呼" frame:CGRectMake(0, KKScreenHeight-50, KKScreenWidth, 50)];
                    btn.layer.cornerRadius = 0;
                    [btn addTarget:self action:@selector(noticeBtnClick) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:btn];
                    [self.view bringSubviewToFront:btn];
                    self.noticeBtn = btn;
                }
            }
            
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismissWithError:KKErrorInfo(error) afterDelay:1.2];
    }];
    
}

//请求小视频数据
-(void)loadVideoData{
    
    NSDictionary *param = @{@"userid":self.uid,@"dynamicsId":self.dynamicsID};
    [FSSharedNetWorkingManager GET:ServiceInterfaceDynamicsabout parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *respDic = (NSDictionary*)responseObject;
        KKLog(@"Dynamics %@",respDic);
        if (respDic&&respDic.count>0) {
            self.videoDic = respDic;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismissWithError:KKErrorInfo(error) afterDelay:1.2];
    }];
}
#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==0) {
        return 1;
    }else if (section==1){
        return 1;
    }else if (section==2){
        return 1;
    }else if (section==3) {
        return 3;
    }else if (section==4){
        return self.baseInfoQ1.count;
    }else if (section==5){
        return self.baseInfoQ2.count;
    }else{
        return self.TABaseInfoQ.count;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        return KKScreenWidth+50;
        
    }else if (indexPath.section==1){
        return self.videoHeight;
    }else if (indexPath.section==2){
        return self.signHeight;
    }
    return 60;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 0.0000001;
    }else if (section==6){
        return 50;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0||section==1) {
        return 0.0000001;
    }
    return 60;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KKScreenWidth, 60)];
    headerView.backgroundColor =[UIColor whiteColor];
    UILabel*headerLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KKScreenWidth-10, 60)];
    [headerView addSubview:headerLab];
    if (section==2){
        headerLab.text = @"内心独白";
    }else if (section==3){
        headerLab.text = @"联系方式";
    }else if (section==4){
        headerLab.text = @"基本资料";
    }else if (section==5){
        headerLab.text = @"基本资料";
    }else if (section==6){
        headerLab.text = @"征友条件";
    }
    
    return headerView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KKWEAKSELF
    if (indexPath.section==0) {
        CarouselCell *cell=[tableView dequeueReusableCellWithIdentifier:cellCarouselIdentifier forIndexPath:indexPath];
        cell.avatarArray = self.currentUser.avatarUrlList;
        cell.age = self.currentUser.age;
        return cell;
    }
    else if (indexPath.section==1){
        VideoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellVideolIdentifier forIndexPath:indexPath];
        cell.hidden = YES;
        if (self.videoDic.count>0) {
            cell.hidden = NO;
            cell.dataDic = self.videoDic;
        }
        cell.heightBlock = ^(CGFloat height){
            weakself.videoHeight = height;
        };
        //跳转 查看动态
        cell.lookDynamicsBlock =^(){
            KKLog(@"查看动态");
            DynamicListViewController *dynamicList = KKViewControllerOfMainSB(@"DynamicListViewController");
            dynamicList.uidStr = weakself.uid;
            [weakself.navigationController pushViewController:dynamicList animated:YES];
        };
        return cell;
    }
    
    else if (indexPath.section==2){
        SignCell *cell=[tableView dequeueReusableCellWithIdentifier:cellSignIdentifier forIndexPath:indexPath];
        if (self.currentUser.sign.length>0) {
            cell.signStr = self.currentUser.sign;
        }
        cell.signHeightBlock = ^(CGFloat height){
            weakself.signHeight = height;
        };
        return cell;
    }
    else if (indexPath.section==3){
        ContactWayCell *cell=[tableView dequeueReusableCellWithIdentifier:cellContactWayIdentifier forIndexPath:indexPath];
        if (self.contactWayArr.count>indexPath.row) {
            cell.contactStr = [self.contactWayArr objectAtIndex:indexPath.row];
        }
        cell.lookBlock = ^(NSString*contactStr){
            //如果是VIP
            if (KKSharedCurrentUser.isVIP==YES) {
                [weakself loadContactDataWith:contactStr];
            }else{
                //跳转付费页面
                [weakself loadContactDataWith:contactStr];
            }
        };
        return cell;
    }
    else if (indexPath.section==4) {
        BaseInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellBaseInfoIdentifier forIndexPath:indexPath];
        if (self.baseInfoA1.count>indexPath.row) {
            cell.textArr = @[self.baseInfoQ1[indexPath.row],self.baseInfoA1[indexPath.row]];
        }
        return cell;
    }
    else if (indexPath.section==5){
        BaseInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellBaseInfoIdentifier forIndexPath:indexPath];
        if (self.baseInfoA2.count>indexPath.row) {
            cell.textArr = @[self.baseInfoQ2[indexPath.row],self.baseInfoA2[indexPath.row]];
        }
        return cell;
    }
    else if (indexPath.section==6){
        BaseInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellBaseInfoIdentifier forIndexPath:indexPath];
        if (self.TABaseInfoA.count>indexPath.row) {
            cell.textArr = @[self.TABaseInfoQ[indexPath.row],self.TABaseInfoA[indexPath.row]];
        }
        return cell;
    }
    return nil;
}
#pragma mark - 私有方法
//查看qq号 微信号 手机号
-(void)loadContactDataWith:(NSString*)contactStr{
    KKLog(@"%@",contactStr);
    NSInteger typeNub;
    if ([contactStr hasPrefix:@"QQ"]) {
        KKLog(@"QQ");
        typeNub = 1;
    }else if ([contactStr hasPrefix:@"微信"]){
        KKLog(@"微信");
        typeNub = 3;
    }else{
        KKLog(@"手机");
        typeNub = 2;
    }
    NSDictionary *param = @{@"userid":self.uid,@"type":@(typeNub)};
    [FSSharedNetWorkingManager GET:ServiceInterfaceGetVipphone parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *respDic = (NSDictionary*)responseObject;
        KKLog(@"%@",respDic);
        NSInteger status = [respDic integerForKey:@"status" defaultValue:0];
        if (status==1) {
            NSString *contact = [respDic stringForKey:@"vipphone" defaultValue:@""];
            if (contact.length>0) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:contact delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


//打招呼按钮
-(void)noticeBtnClick{
    //已有过对话
    if (self.hasConversation==YES) {
        KKLog(@"聊天");

        
    }
    //已打过招呼 没对话
    else if (self.currentUser.noticedToday == YES || self.noticeBtn.selected == YES) {
        KKLog(@"已打招呼");
       
        NSDictionary *param=@{@"userid":KKSharedCurrentUser.userId,@"toid":self.uid,@"type":@(1)};
        [FSSharedNetWorkingManager GET:ServiceInterfaceSeduce parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *respDic = (NSDictionary*)responseObject;
            KKLog(@"seduce %@",respDic);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        //发一条本地信息
        NSArray *arr=@[@"你好，看了你的资料感觉你就是我要找的那个",@"咱们可以聊聊不",@"你好啊!交个朋友好吗?"];
        int value = arc4random() % (3);
        
        NSDictionary *med=@{@"content":KKStringWithFormat(@"[招呼信息]：%@",arr[value])};
        NSDictionary *dic=@{@"fromid":self.currentUser.userId,@"avatar":self.currentUser.avatarUrl,@"nickname":self.currentUser.nickName,@"age":@(self.currentUser.age),@"msgtype":@(ONSMessageType_Text),@"replytype":@(ONSReplyType_Contact),@"medirlist":med};
        
        [KKSharedONSChatManager sendMessage:dic];
        
        //是从聊天过来的，返回聊天
        for (UIViewController *viewController in self.navigationController.viewControllers) {
            if([viewController isKindOfClass:[ChatViewController class]])
            {
                [self.navigationController popToViewController:viewController animated:YES];
                return;
            }
        }
        
        ChatViewController *chatVC=KKViewControllerOfMainSB(@"ChatViewController");
        chatVC.targetId=self.currentUser.userId;
        chatVC.targetNickName=self.currentUser.nickName;
        chatVC.targetIdAvaterUrl=self.currentUser.avatarUrl;
        [self.navigationController pushViewController:chatVC animated:YES];
        
    }else{
        KKLog(@"招呼");

        NSDictionary *param = @{@"uid":self.uid};
        [FSSharedNetWorkingManager POST:ServiceInterfaceGreet parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *respDic = (NSDictionary*)responseObject;
            KKLog(@"greet %@",respDic);
            NSInteger status = [respDic integerForKey:@"status" defaultValue:0];
            if (status==1) {
                self.noticeBtn.selected = YES;
                [self.noticeBtn setTitle:@"已打招呼，去聊天" forState:UIControlStateSelected];
                [self.noticeBtn setTitle:@"已打招呼，去聊天" forState:UIControlStateNormal];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        }];
    }
}

-(void)rightItemClick{
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"举报", nil];
    [sheet showInView:self.view];
}
#pragma mark - Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [SVProgressHUD showSuccessWithStatus:@"举报成功"];
    }
}
@end
