//
//  PartnerConditionsViewController.m
//  ONSChat
//
//  Created by 王磊 on 2016/12/13.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "PartnerConditionsViewController.h"
#import "PartnerAgeCell.h"
#import "PartnerHeightCell.h"
#import "PartnerGraduateCell.h"
#import "PartnerIncomeCell.h"
#import "PartnerAddressCell.h"

#define cellAgeIdentifier @"PartnerAgeCell"
#define cellHeightIdentifier @"PartnerHeightCell"
#define cellGraduateIdentifier @"PartnerGraduateCell"
#define cellIncomeIdentifier @"PartnerIncomeCell"
#define cellAddressIdentifier @"PartnerAddressCell"

@interface PartnerConditionsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) CGFloat cellHeight;
@end

@implementation PartnerConditionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerNib:[UINib nibWithNibName:cellAgeIdentifier bundle:nil] forCellReuseIdentifier:cellAgeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:cellHeightIdentifier bundle:nil] forCellReuseIdentifier:cellHeightIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:cellGraduateIdentifier bundle:nil] forCellReuseIdentifier:cellGraduateIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:cellIncomeIdentifier bundle:nil] forCellReuseIdentifier:cellIncomeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:cellAddressIdentifier bundle:nil] forCellReuseIdentifier:cellAddressIdentifier];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark = UITabelViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //按钮高度*行数+顶部文案高度+间隙*行数
    if (indexPath.section==0) {
        return KKScreenWidth*(50/320.0)*6+45+6;
    }else if (indexPath.section==1){
        return KKScreenWidth*(50/320.0)*4+45+4;
    }else if (indexPath.section==2){
        return KKScreenWidth*(50/320.0)*3+45+3;
    }else if (indexPath.section==3){
        return KKScreenWidth*(50/320.0)*3+45+3;
    }else{
        return KKScreenWidth*(50/320.0)*9+45+9;
    }
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
    
}
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==0) {
        PartnerAgeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellAgeIdentifier forIndexPath:indexPath];
        return cell;
    }else if (indexPath.section==1){
        PartnerHeightCell *cell = [tableView dequeueReusableCellWithIdentifier:cellHeightIdentifier forIndexPath:indexPath];
        return cell;
    }else if (indexPath.section==2){
        PartnerGraduateCell *cell = [tableView dequeueReusableCellWithIdentifier:cellGraduateIdentifier forIndexPath:indexPath];
        return cell;
    }else if (indexPath.section==3){
        PartnerIncomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIncomeIdentifier forIndexPath:indexPath];
        return cell;
    }else {
        PartnerAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellAddressIdentifier forIndexPath:indexPath];
        return cell;
    }
}

- (IBAction)saveBtnClick:(id)sender {
    //发通知 将已选信息存入本地Plist
    [KKNotificationCenter postNotificationName:@"savePartnerConditions" object:nil];

    [SVProgressHUD showSuccessWithStatus:@"保存成功" duration:1.2];
}

@end
