//
//  MyInfoViewController.m
//  ONSChat
//
//  Created by 王磊 on 2016/12/7.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "MyInfoViewController.h"
#import "MyHobbyCell.h"
#import "ContactInfoCell.h"
#import "MySignCell.h"

#define cellHobbyIdentifier @"MyHobbyCell"
#define cellContactInfoIdentifier @"ContactInfoCell"
#define cellMySignIdentifier @"MySignCell"

@interface MyInfoViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet ONSButtonPurple *saveInfoBtn;
@property (nonatomic, strong) NSArray *hobbyArr;
@property (nonatomic, strong) NSArray *personalityArr;
@property (nonatomic, assign) CGFloat hobbyCellH;
@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.hobbyArr = [NSArray array];
    self.personalityArr = [NSArray array];
    self.hobbyCellH = 0.0;
    
    [self.tableView registerNib:[UINib nibWithNibName:cellHobbyIdentifier bundle:nil] forCellReuseIdentifier:cellHobbyIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:cellContactInfoIdentifier bundle:nil] forCellReuseIdentifier:cellContactInfoIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:cellMySignIdentifier bundle:nil] forCellReuseIdentifier:cellMySignIdentifier];
    
    [self loadAllConst];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadAllConst{
    [FSSharedNetWorkingManager GET:ServiceInterfaceConstAll parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *respDic = (NSDictionary*)responseObject;
        if (respDic&&respDic.count>0) {
            NSDictionary *dataDic = [respDic objectForKey:@"data"];
            if (dataDic&&dataDic.count>0) {
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
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return self.hobbyCellH;
    
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
        MyHobbyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellHobbyIdentifier forIndexPath:indexPath];
        cell.cellHeight = ^(CGFloat height){
            weakself.hobbyCellH = height;
        };
        cell.titleLab.text = @"兴趣爱好";
        cell.dataArr = self.hobbyArr;
        return cell;
    }else if (indexPath.section==1){
        MyHobbyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellHobbyIdentifier forIndexPath:indexPath];
        cell.cellHeight = ^(CGFloat height){
            weakself.hobbyCellH = height;
        };
        cell.titleLab.text = @"个性特征";
        cell.dataArr = self.personalityArr;
        return cell;
    }else if (indexPath.section==2){
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
    
    
}

@end
