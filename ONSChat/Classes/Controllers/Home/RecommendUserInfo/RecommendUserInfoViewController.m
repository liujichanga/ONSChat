//
//  RecommendUserInfoViewController.m
//  ONSChat
//
//  Created by 王磊 on 2016/11/26.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "RecommendUserInfoViewController.h"
#import "BaseInfoCell.h"
#import "SignCell.h"
#import "ContactWayCell.h"
#import "CarouselCell.h"

#define cellBaseInfoIdentifier @"BaseInfoCell"
#define cellSignIdentifier @"SignCell"
#define cellContactWayIdentifier @"ContactWayCell"
#define cellCarouselIdentifier @"CarouselCell"

@interface RecommendUserInfoViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//选项
@property (nonatomic, strong) NSArray *baseInfoQ1;
@property (nonatomic, strong) NSArray *baseInfoQ2;
@property (nonatomic, strong) NSArray *TABaseInfoQ;
//答案
@property (nonatomic, strong) NSArray *baseInfoA1;
@property (nonatomic, strong) NSArray *baseInfoA2;
@property (nonatomic, strong) NSArray *TABaseInfoA;
//内心独白
@property (nonatomic, strong) NSString *signStr;
@property (nonatomic, assign) CGFloat signHeight;
//联系方式
@property (nonatomic, strong) NSArray *contactWayArr;
//图片轮播
@property (nonatomic, strong) NSArray *avatarArray;
//年龄
@property (nonatomic, strong) NSString *ageStr;
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
    self.avatarArray = [NSArray array];

    self.title = self.nickStr;
    
    [self.tableView registerNib:[UINib nibWithNibName:cellBaseInfoIdentifier bundle:nil] forCellReuseIdentifier:cellBaseInfoIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:cellSignIdentifier bundle:nil] forCellReuseIdentifier:cellSignIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:cellContactWayIdentifier bundle:nil] forCellReuseIdentifier:cellContactWayIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:cellCarouselIdentifier bundle:nil] forCellReuseIdentifier:cellCarouselIdentifier];
    
    [self loadInfoData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadInfoData{
    [SVProgressHUD show];
    NSDictionary *param = @{@"uid":@(self.uid)};
    [FSSharedNetWorkingManager GET:ServiceInterfaceUserInfo parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *respDic = (NSDictionary*)responseObject;
        KKLog(@"资料 %@",respDic);
        if (respDic&&respDic.count>0) {
            [SVProgressHUD dismiss];
            NSDictionary *userDic = [respDic objectForKey:@"user"];
            NSString*job = [userDic stringForKey:@"job" defaultValue:@""];
            NSString*income = [userDic stringForKey:@"income" defaultValue:@""];
            NSString*blood = [userDic stringForKey:@"blood" defaultValue:@""];
            NSString*weight = [userDic stringForKey:@"weight" defaultValue:@""];
            NSString*astro = [userDic stringForKey:@"astro" defaultValue:@""];
            NSString*marry = [userDic stringForKey:@"marry" defaultValue:@""];
            NSString*house = [userDic stringForKey:@"house" defaultValue:@""];
            NSString*car = [userDic stringForKey:@"car" defaultValue:@""];
            self.baseInfoA1 = [NSArray arrayWithObjects:job,income,blood,weight,astro,marry,house,car,nil];
            
            NSString*pos = [userDic stringForKey:@"pos" defaultValue:@""];
            NSString*lovetype = [userDic stringForKey:@"lovetype" defaultValue:@""];
            NSString*distance = [userDic stringForKey:@"distance" defaultValue:@""];
            NSString*child = [userDic stringForKey:@"child" defaultValue:@""];
            NSString*livetog = [userDic stringForKey:@"livetog" defaultValue:@""];
            NSString*withparent = [userDic stringForKey:@"withparent" defaultValue:@""];
            NSString*hobby = [userDic stringForKey:@"hobby" defaultValue:@""];
            NSString*personality = [userDic stringForKey:@"personality" defaultValue:@""];
            self.baseInfoA2 = [NSArray arrayWithObjects:pos,lovetype,distance,child,livetog,withparent,hobby,personality, nil];
           
            NSString*taAddress = [userDic stringForKey:@"taAddress" defaultValue:@""];
            NSString*taAge = [userDic stringForKey:@"taAge" defaultValue:@""];
            NSString*taIncome = [userDic stringForKey:@"taIncome" defaultValue:@""];
            NSString*taHeight = [userDic stringForKey:@"taHeight" defaultValue:@""];
            NSString*taGraduate = [userDic stringForKey:@"taGraduate" defaultValue:@""];
            self.TABaseInfoA = [NSArray arrayWithObjects:taAddress,taAge,taIncome,taHeight,taGraduate,nil];
            
            self.signStr = [userDic stringForKey:@"sign" defaultValue:@""];
            self.avatarArray = [respDic objectForKey:@"avatarlist"];
            self.ageStr = [userDic stringForKey:@"age" defaultValue:@""];
            
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismissWithError:KKErrorInfo(error) afterDelay:1.2];
    }];
    
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else if (section==1){
        return 1;
    }else if (section==2){
        return 3;
    }else if (section==3) {
        return self.baseInfoQ1.count;
    }else if (section==4){
        return self.baseInfoQ2.count;
    }else {
        return self.TABaseInfoQ.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return KKScreenWidth+50;
        
    }else if (indexPath.section==1){
        return self.signHeight;
    }
    return 60;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.0000001;
    }
    return 60;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KKScreenWidth, 60)];
    headerView.backgroundColor =[UIColor whiteColor];
    UILabel*headerLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KKScreenWidth-10, 60)];
    [headerView addSubview:headerLab];
    if (section==0) {
        
    }else if (section==1){
        headerLab.text = @"内心独白";
    }else if (section==2){
        headerLab.text = @"联系方式";
    }else if (section==3){
        headerLab.text = @"基本资料";
    }else if (section==4){
        headerLab.text = @"基本资料";
    }else if (section==5){
        headerLab.text = @"征友条件";
    }
    return headerView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KKWEAKSELF
    if (indexPath.section==0) {
        CarouselCell *cell=[tableView dequeueReusableCellWithIdentifier:cellCarouselIdentifier forIndexPath:indexPath];
        if (self.avatarArray.count>0) {
            cell.avatarArray = self.avatarArray;
            cell.ageStr = self.ageStr;
        }
        return cell;
    }
    else if (indexPath.section==1){
        SignCell *cell=[tableView dequeueReusableCellWithIdentifier:cellSignIdentifier forIndexPath:indexPath];
        if (self.signStr.length>0) {
            cell.signStr = self.signStr;
        }
        cell.signHeightBlock = ^(CGFloat height){
            weakself.signHeight = height;
        };
        return cell;
    }
    else if (indexPath.section==2){
        ContactWayCell *cell=[tableView dequeueReusableCellWithIdentifier:cellContactWayIdentifier forIndexPath:indexPath];
        if (self.contactWayArr.count>indexPath.row) {
            cell.contactStr = [self.contactWayArr objectAtIndex:indexPath.row];
        }
        cell.lookBlock = ^(){
            KKLog(@"立即查看");
        };
        return cell;
    }
    else if (indexPath.section==3) {
        BaseInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellBaseInfoIdentifier forIndexPath:indexPath];
        if (self.baseInfoA1.count>indexPath.row) {
            cell.textArr = @[self.baseInfoQ1[indexPath.row],self.baseInfoA1[indexPath.row]];
        }
        return cell;
    }
    else if (indexPath.section==4){
        BaseInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellBaseInfoIdentifier forIndexPath:indexPath];
        if (self.baseInfoA2.count>indexPath.row) {
            cell.textArr = @[self.baseInfoQ2[indexPath.row],self.baseInfoA2[indexPath.row]];
        }
        return cell;
    }
    else if (indexPath.section==5){
        BaseInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellBaseInfoIdentifier forIndexPath:indexPath];
        if (self.TABaseInfoA.count>indexPath.row) {
            cell.textArr = @[self.TABaseInfoQ[indexPath.row],self.TABaseInfoA[indexPath.row]];
        }
        return cell;
    }
    return nil;
}
@end
