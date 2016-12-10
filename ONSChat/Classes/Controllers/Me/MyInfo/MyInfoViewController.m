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
@property (nonatomic, strong) NSArray *hobbyArr;
@property (nonatomic, strong) NSArray *personalityArr;
@property (nonatomic, assign) CGFloat hobbyCellH;
@property (nonatomic, assign) CGFloat personalityCellH;

@property (nonatomic, strong) MyInfoPickerView *infoPickerView;
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
    
    [self loadAllConst];
    
    MyInfoPickerView *infoPicker = [MyInfoPickerView createMyInfoPickerViewFrame:self.view.bounds inView:self.view];
    self.infoPickerView = infoPicker;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadAllConst{
    [FSSharedNetWorkingManager GET:ServiceInterfaceConstAll parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *respDic = (NSDictionary*)responseObject;
        KKLog(@"const %@",respDic);
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

    }else if (indexPath.section==3){
        return self.personalityCellH;
    }else if (indexPath.section==4){
        return 132;
    }else{
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
        cell.infoTypeBlock=^(MyInfoType type){
            
            [weakself.infoPickerView showInfoPickerViewWithType:type];
        };
        return cell;
    }else if (indexPath.section==1) {
        MyBaseInfo2Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellMyBaseInfo2Identifier forIndexPath:indexPath];
        cell.infoTypeBlock=^(MyInfoType type){
            
            [weakself.infoPickerView showInfoPickerViewWithType:type];
        };
        return cell;
    }else if (indexPath.section==2) {
        MyHobbyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellHobbyIdentifier forIndexPath:indexPath];
        cell.cellHeight = ^(CGFloat height){
            weakself.hobbyCellH = height;
        };
        cell.dataArr = self.hobbyArr;
        return cell;
    }else if (indexPath.section==3){
        MyPersonalityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellMyPersonalityIdentifier forIndexPath:indexPath];
        cell.cellHeight = ^(CGFloat height){
            weakself.personalityCellH = height;
        };
        cell.dataArr = self.personalityArr;
        return cell;
    }else if (indexPath.section==4){
        ContactInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellContactInfoIdentifier forIndexPath:indexPath];
        return cell;
    }else{
        MySignCell *cell = [tableView dequeueReusableCellWithIdentifier:cellMySignIdentifier forIndexPath:indexPath];
        return cell;
    }

}
-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{

}

- (IBAction)saveInfoBtnClick:(id)sender {
   
    [KKNotificationCenter postNotificationName:@"saveInfo" object:nil];
}

@end
