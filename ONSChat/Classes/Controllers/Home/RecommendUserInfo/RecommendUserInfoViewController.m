//
//  RecommendUserInfoViewController.m
//  ONSChat
//
//  Created by 王磊 on 2016/11/26.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "RecommendUserInfoViewController.h"
#import "BaseInfoCell.h"

#define cellBaseInfoIdentifier @"BaseInfoCell"


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
@end

@implementation RecommendUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.baseInfoQ1 = @[@"职业",@"收入",@"血型",@"体重",@"星座",@"婚姻状况",@"是否有房",@"是否有车"];
    self.baseInfoQ2 = @[@"魅力部位",@"喜欢的异性类型",@"是否接受异地恋",@"是否要小孩",@"是否接受婚前性行为",@"是否愿意婚后与父母同住",@"兴趣爱好",@"个性特征"];
    self.TABaseInfoQ = @[@"居住地",@"年龄范围",@"收入",@"身高",@"最低学历"];
    self.baseInfoA1 = [NSArray array];
    self.baseInfoA2 = [NSArray array];
    self.TABaseInfoA = [NSArray array];

    self.title = self.nickStr;
    
    [self.tableView registerNib:[UINib nibWithNibName:cellBaseInfoIdentifier bundle:nil] forCellReuseIdentifier:cellBaseInfoIdentifier];
    [self loadInfoData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadInfoData{
    NSDictionary *param = @{@"uid":@(self.uid)};
    [FSSharedNetWorkingManager GET:ServiceInterfaceUserInfo parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *respDic = (NSDictionary*)responseObject;
        KKLog(@"资料 %@",respDic);
        if (respDic&&respDic.count>0) {
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
            
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return self.baseInfoQ1.count;
    }else if (section==1){
        return self.baseInfoQ2.count;
    }else{
        return self.TABaseInfoQ.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        BaseInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellBaseInfoIdentifier forIndexPath:indexPath];
        if (self.baseInfoA1.count>indexPath.row) {
            cell.textArr = @[self.baseInfoQ1[indexPath.row],self.baseInfoA1[indexPath.row]];
        }
        return cell;
    }else if (indexPath.section==1){
        BaseInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellBaseInfoIdentifier forIndexPath:indexPath];
        if (self.baseInfoA2.count>indexPath.row) {
            cell.textArr = @[self.baseInfoQ2[indexPath.row],self.baseInfoA2[indexPath.row]];
        }
        return cell;
    }else if (indexPath.section==2){
        BaseInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellBaseInfoIdentifier forIndexPath:indexPath];
        if (self.TABaseInfoA.count>indexPath.row) {
            cell.textArr = @[self.TABaseInfoQ[indexPath.row],self.TABaseInfoA[indexPath.row]];
        }
        return cell;
    }
    return nil;
}
@end
