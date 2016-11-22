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

#define cellHeadIdentifier @"HeadCell"
#define cellVIPIdentifier @"VIPCell"

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
    else return 15;
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
            return cell;
        }
        else if(indexPath.row==1)
        {
            VIPCell *cell=[tableView dequeueReusableCellWithIdentifier:cellVIPIdentifier forIndexPath:indexPath];
            return cell;
        }
        else
        {
            VIPCell *cell=[tableView dequeueReusableCellWithIdentifier:cellVIPIdentifier forIndexPath:indexPath];
            return cell;
        }
        
    }
    else if(indexPath.section == 2)//我的资料
    {
        //if(indexPath.row==0)
        {
            UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"infocell"];
            return cell;
        }
       
        
    }
    else//资料
    {
        UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"infocell"];
        return cell;
    }
    
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
   
}

@end
