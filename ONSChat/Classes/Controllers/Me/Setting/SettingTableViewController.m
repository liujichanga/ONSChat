//
//  SettingTableViewController.m
//  ONSChat
//
//  Created by liujichang on 2016/11/26.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "SettingTableViewController.h"
#import <RongIMLib/RongIMLib.h>

@interface SettingTableViewController ()

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0) return 4;
    else return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"settingcell"];
        if(cell==nil)
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingcell"];
        }
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
       if(indexPath.row==0)
       {
           cell.textLabel.text=@"用户关心的问题";
       }
        else if(indexPath.row==1)
        {
            cell.textLabel.text=@"重置密码";
        }
        else if(indexPath.row==2)
        {
            cell.textLabel.text=@"清除缓存";
        }
        else
        {
            cell.textLabel.text=@"关于我们";
        }
        return cell;
    }
    else
    {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"settingcell"];
        if(cell==nil)
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingcell"];
        }
        cell.textLabel.text=@"退出账号";
        return cell;
    }
    
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if(indexPath.section==0)
    {
        if(indexPath.row==0)
        {
            //用户关心的问题
        }
        else if(indexPath.row==1)
        {
            //重置密码
            
        }
        else if(indexPath.row==2)
        {
            //清除缓存
        }
        else if(indexPath.row==3)
        {
            //关于我们
        }
    }
    else if(indexPath.section==1)
    {
        if(indexPath.row==0)
        {
            //退出账号
            //融云退出
            [[RCIMClient sharedRCIMClient] logout];
            
            //清除聊天信息
            [ONSChatManager releaseSingleton];
            //清除当前用户信息
            [KKUserManager releaseSingleton];
            //plist数据清除
            [KKLocalPlistManager releaseSingleton];
            //网络
            [FSNetWorking releaseSingleton];

            
            self.view.window.rootViewController = KKViewControllerOfMainSB(@"LoginNavigationController");
            
        }
       
    }
    
}

@end
