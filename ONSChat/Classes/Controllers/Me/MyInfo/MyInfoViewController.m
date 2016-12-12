//
//  MyInfoViewController.m
//  ONSChat
//
//  Created by 王磊 on 2016/12/7.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "MyInfoViewController.h"
#import "MyHobbyCell.h"
#import "MyPersonalityCell.h"
#import "ContactInfoCell.h"
#import "MySignCell.h"
#import "MyBaseInfo1Cell.h"
#import "MyBaseInfo2Cell.h"
#import "MyInfoPickerView.h"

#define cellHobbyIdentifier @"MyHobbyCell"
#define cellContactInfoIdentifier @"ContactInfoCell"
#define cellMySignIdentifier @"MySignCell"
#define cellMyPersonalityIdentifier @"MyPersonalityCell"
#define cellMyBaseInfo1Identifier @"MyBaseInfo1Cell"
#define cellMyBaseInfo2Identifier @"MyBaseInfo2Cell"

@interface MyInfoViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet ONSButtonPurple *saveInfoBtn;
//保存兴趣数据
@property (nonatomic, strong) NSArray *hobbyArr;
//保存个性数据
@property (nonatomic, strong) NSArray *personalityArr;
//兴趣cell高度
@property (nonatomic, assign) CGFloat hobbyCellH;
//个性cell高度
@property (nonatomic, assign) CGFloat personalityCellH;
//选项弹出view
@property (nonatomic, strong) MyInfoPickerView *infoPickerView;
@property (nonatomic, strong) KKUser *tempUser;
@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.hobbyArr = [NSArray array];
    self.personalityArr = [NSArray array];
    self.hobbyCellH = 0.0;
    self.personalityCellH = 0.0;
    
    [self.tableView registerNib:[UINib nibWithNibName:cellHobbyIdentifier bundle:nil] forCellReuseIdentifier:cellHobbyIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:cellContactInfoIdentifier bundle:nil] forCellReuseIdentifier:cellContactInfoIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:cellMySignIdentifier bundle:nil] forCellReuseIdentifier:cellMySignIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:cellMyPersonalityIdentifier bundle:nil] forCellReuseIdentifier:cellMyPersonalityIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:cellMyBaseInfo1Identifier bundle:nil] forCellReuseIdentifier:cellMyBaseInfo1Identifier];
    [self.tableView registerNib:[UINib nibWithNibName:cellMyBaseInfo2Identifier bundle:nil] forCellReuseIdentifier:cellMyBaseInfo2Identifier];
    
    [self loadInfoData];
    [self loadAllConst];
    
    MyInfoPickerView *infoPicker = [MyInfoPickerView createMyInfoPickerViewFrame:self.view.bounds inView:self.view];
    self.infoPickerView = infoPicker;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//请求基本信息数据
-(void)loadInfoData{

    NSDictionary *param = @{@"uid":@(0)};
    [FSSharedNetWorkingManager GET:ServiceInterfaceUserInfo parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *respDic = (NSDictionary*)responseObject;
        KKLog(@"资料 %@",respDic);
        if (respDic&&respDic.count>0) {
            self.tempUser = [[KKUser alloc]initWithDicFull:respDic];
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismissWithError:KKErrorInfo(error) afterDelay:1.2];
    }];
}

//加载所有选项数据
-(void)loadAllConst{
    [FSSharedNetWorkingManager GET:ServiceInterfaceConstAll parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *respDic = (NSDictionary*)responseObject;
//        KKLog(@"const %@",respDic);
        if (respDic&&respDic.count>0) {
            NSDictionary *dataDic = [respDic objectForKey:@"data"];
            if (dataDic&&dataDic.count>0) {
                self.infoPickerView.dataDic = dataDic;
                NSString *hobbyStr = [dataDic stringForKey:@"hobby" defaultValue:@""];
                self.hobbyArr = [hobbyStr componentsSeparatedByString:@","];
                NSString *persanalityStr = [dataDic stringForKey:@"personality" defaultValue:@""];
                self.personalityArr = [persanalityStr componentsSeparatedByString:@","];
                [self.tableView reloadData];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:KKErrorInfo(error) duration:1.2];
    }];
}

#pragma mark = UITabelViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 705;
    }
    else if (indexPath.section==1) {
        return 441;
    }
    else if (indexPath.section==2) {
        return self.hobbyCellH;
    }
    else if (indexPath.section==3){
        return self.personalityCellH;
    }
    else if (indexPath.section==4){
        return 132;
    }
    else{
        return 166;
    }
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
    
}
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KKWEAKSELF
    if (indexPath.section==0) {
        MyBaseInfo1Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellMyBaseInfo1Identifier forIndexPath:indexPath];
        if (self.tempUser) {
            cell.user = self.tempUser;
        }
        cell.infoTypeBlock=^(MyInfoType type){
            [weakself.infoPickerView showInfoPickerViewWithType:type];
        };
        return cell;
    }else if (indexPath.section==1) {
        MyBaseInfo2Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellMyBaseInfo2Identifier forIndexPath:indexPath];
        if (self.tempUser) {
            cell.user = self.tempUser;
        }
        cell.infoTypeBlock=^(MyInfoType type){
            [weakself.infoPickerView showInfoPickerViewWithType:type];
        };
        return cell;
    }else if (indexPath.section==2) {
        MyHobbyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellHobbyIdentifier forIndexPath:indexPath];
        if (self.tempUser) {
            cell.selectedHobbyStr = self.tempUser.hobby;
        }
        cell.cellHeight = ^(CGFloat height){
            weakself.hobbyCellH = height;
        };
        cell.dataArr = self.hobbyArr;
        return cell;
    }else if (indexPath.section==3){
        MyPersonalityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellMyPersonalityIdentifier forIndexPath:indexPath];
        if (self.tempUser) {
            cell.selectedInfoStr = self.tempUser.personality;
        }
        cell.cellHeight = ^(CGFloat height){
            weakself.personalityCellH = height;
        };
        cell.dataArr = self.personalityArr;
        return cell;
    }else if (indexPath.section==4){
        ContactInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellContactInfoIdentifier forIndexPath:indexPath];
        if (self.tempUser) {
            cell.user = self.tempUser;
        }
        return cell;
    }else{
        MySignCell *cell = [tableView dequeueReusableCellWithIdentifier:cellMySignIdentifier forIndexPath:indexPath];
        if (self.tempUser) {
            cell.userSign = self.tempUser.sign;
        }
        return cell;
    }

}

//提交资料
- (IBAction)saveInfoBtnClick:(id)sender {
    [SVProgressHUD show];
    [KKNotificationCenter postNotificationName:@"saveInfo" object:nil];
    NSURLComponents *component = [NSURLComponents componentsWithString:ServiceInterfaceUserEdit];
    component.queryItems = @[[NSURLQueryItem queryItemWithName:@"birthday" value:KKSharedCurrentUser.birthday],
                             [NSURLQueryItem queryItemWithName:@"nickname" value:KKSharedCurrentUser.nickName],
                             [NSURLQueryItem queryItemWithName:@"channel" value:ChannelId],
                             [NSURLQueryItem queryItemWithName:@"sign" value:KKSharedCurrentUser.sign],
                             [NSURLQueryItem queryItemWithName:@"address" value:KKSharedCurrentUser.address],
                             [NSURLQueryItem queryItemWithName:@"height" value:[NSString stringWithFormat:@"%zd",KKSharedCurrentUser.height]],
                             [NSURLQueryItem queryItemWithName:@"weight" value:[NSString stringWithFormat:@"%zd",KKSharedCurrentUser.weight]],
                             [NSURLQueryItem queryItemWithName:@"blood" value:KKSharedCurrentUser.blood],
                             [NSURLQueryItem queryItemWithName:@"graduate" value:KKSharedCurrentUser.graduate],
                             [NSURLQueryItem queryItemWithName:@"job" value:KKSharedCurrentUser.job],
                             [NSURLQueryItem queryItemWithName:@"income" value:KKSharedCurrentUser.income],
                             [NSURLQueryItem queryItemWithName:@"house" value:KKSharedCurrentUser.hasHouse],
                             [NSURLQueryItem queryItemWithName:@"car" value:[NSString stringWithFormat:@"%zd",KKSharedCurrentUser.hasCar]],
                             [NSURLQueryItem queryItemWithName:@"marry" value:KKSharedCurrentUser.marry],
                             [NSURLQueryItem queryItemWithName:@"child" value:KKSharedCurrentUser.child],
                             [NSURLQueryItem queryItemWithName:@"distance" value:KKSharedCurrentUser.distanceLove],
                             [NSURLQueryItem queryItemWithName:@"lovetype" value:KKSharedCurrentUser.lovetype],
                             [NSURLQueryItem queryItemWithName:@"livetog" value:KKSharedCurrentUser.livetog],
                             [NSURLQueryItem queryItemWithName:@"withparent" value:KKSharedCurrentUser.withparent],
                             [NSURLQueryItem queryItemWithName:@"pos" value:KKSharedCurrentUser.pos],
                             [NSURLQueryItem queryItemWithName:@"hobby" value:KKSharedCurrentUser.hobby],
                             [NSURLQueryItem queryItemWithName:@"personality" value:KKSharedCurrentUser.personality],
                             [NSURLQueryItem queryItemWithName:@"qq" value:KKSharedCurrentUser.qq],
                             [NSURLQueryItem queryItemWithName:@"phone" value:KKSharedCurrentUser.phone]
                             ];
    
    [FSSharedNetWorkingManager POST:component.URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = (NSDictionary*)responseObject;
        KKLog(@"edit :%@",responseObject);
        NSInteger status = [dic integerForKey:@"status" defaultValue:0];
        if (status==1) {
            [SVProgressHUD dismissWithSuccess:@"保存成功" afterDelay:1.2];
        }else{
            [SVProgressHUD dismissWithError:@"保存失败" afterDelay:1.2];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismissWithError:KKErrorInfo(error) afterDelay:1.2];
    }];
}
//计算资料完成度
-(void)infoCompletionPercentage{
    
    
    
}
@end
