//
//  MeViewController.m
//  ONSChat
//
//  Created by liujichang on 2016/11/21.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "MeViewController.h"
#import "HeadCell.h"
#import "VIPCell.h"
#import "MeInfoCell.h"


#define cellHeadIdentifier @"HeadCell"
#define cellVIPIdentifier @"VIPCell"
#define cellMeInfoIdentifier @"MeInfoCell"


@interface MeViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //使用registerNib 方法可以从XIB加载控件
    [self.tableView registerNib:[UINib nibWithNibName:cellHeadIdentifier bundle:nil] forCellReuseIdentifier:cellHeadIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:cellVIPIdentifier bundle:nil] forCellReuseIdentifier:cellVIPIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:cellMeInfoIdentifier bundle:nil] forCellReuseIdentifier:cellMeInfoIdentifier];

    NotificationView *notificationView=[[NotificationView alloc] initWithFrame:CGRectMake(10, 74, KKScreenWidth-20, 35)];
    [self.view addSubview:notificationView];
    [notificationView setNotificationNum:30];
    
    ONSButton *btn=[ONSButton ONSButtonWithTitle:@"wodfw" frame:CGRectMake(60, 200, 100, 30)];
    [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0) return 1;
    else if(section==1) return 3;
    else if(section==2) return 3;
    else return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
         return 158;
    }
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        return 0.01;
    }
    else return 0.01;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0)
    {
        HeadCell *cell=[tableView dequeueReusableCellWithIdentifier:cellHeadIdentifier forIndexPath:indexPath];
        return cell;
    }
    else if(indexPath.section == 1)
    {
        if(indexPath.row==0)
        {
            VIPCell *cell=[tableView dequeueReusableCellWithIdentifier:cellVIPIdentifier forIndexPath:indexPath];
            [cell showText:indexPath.row];
            return cell;
        }
        else if(indexPath.row==1)
        {
            VIPCell *cell=[tableView dequeueReusableCellWithIdentifier:cellVIPIdentifier forIndexPath:indexPath];
            [cell showText:indexPath.row];

            return cell;
        }
        else
        {
            VIPCell *cell=[tableView dequeueReusableCellWithIdentifier:cellVIPIdentifier forIndexPath:indexPath];
            [cell showText:indexPath.row];

            return cell;
        }
        
    }
    else if(indexPath.section == 2)//我的资料
    {
        if(indexPath.row==0)
        {
            MeInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellMeInfoIdentifier forIndexPath:indexPath];
            cell.iconImageView.image=[UIImage imageNamed:@"data_img"];
            cell.infoTextLabel.text=@"我的资料";
            return cell;
        }
        else if(indexPath.row==1)
        {
            MeInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellMeInfoIdentifier forIndexPath:indexPath];
            cell.iconImageView.image=[UIImage imageNamed:@"data_img"];
            cell.infoTextLabel.text=@"我的动态";
            return cell;
        }
        else
        {
            MeInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellMeInfoIdentifier forIndexPath:indexPath];
            cell.iconImageView.image=[UIImage imageNamed:@"gallery_img"];
            cell.infoTextLabel.text=@"我的相册";
            return cell;
        }
        
    }
    else//资料
    {
        if(indexPath.row==0)
        {
            MeInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellMeInfoIdentifier forIndexPath:indexPath];
            cell.iconImageView.image=[UIImage imageNamed:@"make_friends_img"];
            cell.infoTextLabel.text=@"征友条件";
            return cell;
        }
        else if(indexPath.row==1)
        {
            MeInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellMeInfoIdentifier forIndexPath:indexPath];
            cell.iconImageView.image=[UIImage imageNamed:@"goods_star_img_1"];
            cell.infoTextLabel.text=@"诚信星级";
            return cell;
        }
        else if(indexPath.row==2)
        {
            MeInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellMeInfoIdentifier forIndexPath:indexPath];
            cell.iconImageView.image=[UIImage imageNamed:@"kefu_img_1"];
            cell.infoTextLabel.text=@"自定义招呼";
            return cell;
        }
        else if(indexPath.row==3)
        {
            MeInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellMeInfoIdentifier forIndexPath:indexPath];
            cell.iconImageView.image=[UIImage imageNamed:@"kefu_img_1"];
            cell.infoTextLabel.text=@"在线客服";
            return cell;
        }
        else
        {
            MeInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellMeInfoIdentifier forIndexPath:indexPath];
            cell.iconImageView.image=[UIImage imageNamed:@"setting_img_1"];
            cell.infoTextLabel.text=@"设置";
            return cell;
        }
       
    }
    
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
   
}

@end
