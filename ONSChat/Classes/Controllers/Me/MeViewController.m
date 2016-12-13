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
#import "SettingTableViewController.h"
#import "MyPhotoViewController.h"
#import "DynamicListViewController.h"
#import "MyInfoViewController.h"
#import "VIPPayViewController.h"
#import "BaoYuePayViewController.h"
#import "HonestyViewController.h"
#import "CustomHiViewController.h"
#import "PartnerConditionsViewController.h"
#import "LikeMeViewController.h"
#import "VisterViewController.h"


#define cellHeadIdentifier @"HeadCell"
#define cellVIPIdentifier @"VIPCell"
#define cellMeInfoIdentifier @"MeInfoCell"


@interface MeViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

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

    //未读数量
    KKNotificationCenterAddObserverOfSelf(unReadCount:, ONSChatManagerNotification_UnReadCount, nil);
    
    if(KKSharedONSChatManager.unReadCount>0)
    {
        [KKNotificationCenter postNotificationName:ONSChatManagerNotification_UnReadCount object:[NSNumber numberWithInteger:KKSharedONSChatManager.unReadCount]];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    KKNotificationCenterRemoveObserverOfSelf;
}

#pragma mark - UnReadCount
-(void)unReadCount:(NSNotification*)notification
{
    if(notification.object)
    {
        NSNumber *num=(NSNumber*)notification.object;
        NSInteger count = [num integerValue];
        UIView *view=[self.view viewWithTag:9990];
        if(view)
        {
            if(count>0)
            {
                NotificationView *notificationView=(NotificationView*)view;
                [notificationView setNotificationNum:count];
            }
            else
            {
                [view removeFromSuperview];
            }
        }
        else
        {
            if(count>0)
            {
                NotificationView *notificationView=[[NotificationView alloc] initWithFrame:CGRectMake(10, 74, KKScreenWidth-20, 35)];
                notificationView.tag=9990;
                [self.view addSubview:notificationView];
                [notificationView setNotificationNum:count];
            }
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    KKLog(@"me view will appear");
    
    [FSSharedNetWorkingManager GET:ServiceInterfaceUserCenter parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = (NSDictionary*)responseObject;
        KKLog(@"usercenter:%@",dic);
        BOOL status=[dic boolForKey:@"status" defaultValue:NO];
        if(status)
        {
            //如果不是IAP，加载服务器数据
            if(!KKSharedGlobalManager.isIAP)
            {
                NSTimeInterval baoyue=[dic longlongForKey:@"baoyueendtime" defaultValue:0]/1000.0;
                KKSharedCurrentUser.baoyueEndTime=[[NSDate dateWithTimeIntervalSince1970:baoyue] stringYearMonthDay];
                NSTimeInterval vip=[dic longlongForKey:@"vipendtime" defaultValue:0]/1000.0;
                KKSharedCurrentUser.vipEndTime=[[NSDate dateWithTimeIntervalSince1970:vip] stringYearMonthDay];
                
                KKSharedCurrentUser.beannum=[dic integerForKey:@"beannum" defaultValue:0];
                KKSharedCurrentUser.isVIP=[dic boolForKey:@"vip" defaultValue:NO];
                KKSharedCurrentUser.isBaoYue=[dic boolForKey:@"msg" defaultValue:NO];
            }
            
            
            KKSharedCurrentUser.isPhone=[dic boolForKey:@"hasPhone" defaultValue:NO];
            
            KKSharedCurrentUser.likedmeNum=[dic integerForKey:@"likednum" defaultValue:0];
            KKSharedCurrentUser.melikeNum=[dic integerForKey:@"likenum" defaultValue:0];
            KKSharedCurrentUser.visitNum=[dic integerForKey:@"visitnum" defaultValue:0];
            
            KKSharedCurrentUser.nickName=[dic stringForKey:@"nickname" defaultValue:@""];
            
            [self.tableView reloadData];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


#pragma mark - UIImagePickerControllerDelegate
/** 打开照片选择器 */
- (void)openImagePickerControllerWithScourceType:(UIImagePickerControllerSourceType)sourceType {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setValue:@(UIStatusBarStyleLightContent) forKey:@"_previousStatusBarStyle"];
    picker.sourceType = sourceType;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


/** 获取到图片后进入这里 */
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // 关闭Picker
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 原图
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    long long int timestamp = [NSDate date].timeIntervalSince1970 * 1000 + arc4random()%1000;
    NSString *imagename=KKStringWithFormat(@"%lld.jpg",timestamp);
    NSString *path = [CacheUserPath stringByAppendingPathComponent:imagename];
    
    NSData *imagedata=UIImageJPEGRepresentation(image, 0.75);
    
    BOOL result = [imagedata writeToFile:path atomically:YES];
    
    if(result)
    {
        [KKSharedLocalPlistManager setKKValue:imagename forKey:Plist_Key_Avatar];
        KKSharedCurrentUser.avatarUrl=[CacheUserPath stringByAppendingPathComponent:imagename];
        
        [self.tableView reloadData];
    }
    
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
        [cell displayInfo];
        KKWEAKSELF
        cell.changeHeadImage=^{
          
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"请选择" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               
                [weakself openImagePickerControllerWithScourceType:UIImagePickerControllerSourceTypeCamera];

            }];
            UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakself openImagePickerControllerWithScourceType:UIImagePickerControllerSourceTypePhotoLibrary];

            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            [alertController addAction:cameraAction];
            [alertController addAction:libraryAction];
            [alertController addAction:cancelAction];
            [weakself presentViewController:alertController animated:YES completion:nil];
            
        };
        
        cell.getBeanBlock=^{
            
            BaoYuePayViewController *baoyueVC=KKViewControllerOfMainSB(@"BaoYuePayViewController");
            baoyueVC.showBean=YES;
            [weakself.navigationController pushViewController:baoyueVC animated:YES];
        };
        cell.vipBlock=^{
            VIPPayViewController *vipVC=KKViewControllerOfMainSB(@"VIPPayViewController");
            [weakself.navigationController pushViewController:vipVC animated:YES];
        };
        cell.baoyueBlock=^{
            BaoYuePayViewController *baoyueVC=KKViewControllerOfMainSB(@"BaoYuePayViewController");
            [weakself.navigationController pushViewController:baoyueVC animated:YES];
        };
        cell.likemeBlock=^{
            
            LikeMeViewController *likemeVC=KKViewControllerOfMainSB(@"LikeMeViewController");
            [weakself.navigationController pushViewController:likemeVC animated:YES];
            [MobClick event:@"007"];
        };
        cell.melikeBlock=^{
            
            LikeMeViewController *likemeVC=KKViewControllerOfMainSB(@"LikeMeViewController");
            likemeVC.isMeLike=YES;
            [weakself.navigationController pushViewController:likemeVC animated:YES];
        };
        cell.visitBlock=^{
            VisterViewController *visterVC=KKViewControllerOfMainSB(@"VisterViewController");
            [weakself.navigationController pushViewController:visterVC animated:YES];
            [MobClick event:@"008"];
        };
        
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
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section==1)
    {
        if(indexPath.row==0)
        {
            //包月写信
            BaoYuePayViewController *baoyueVC=KKViewControllerOfMainSB(@"BaoYuePayViewController");
            [self.navigationController pushViewController:baoyueVC animated:YES];
            [MobClick event:@"004"];
        }
        else if(indexPath.row==1)
        {
            //vip会员
            VIPPayViewController *vipVC=KKViewControllerOfMainSB(@"VIPPayViewController");
            [self.navigationController pushViewController:vipVC animated:YES];
            [MobClick event:@"005"];
        }
        else if(indexPath.row==2)
        {
            //红豆
            BaoYuePayViewController *baoyueVC=KKViewControllerOfMainSB(@"BaoYuePayViewController");
            baoyueVC.showBean=YES;
            [self.navigationController pushViewController:baoyueVC animated:YES];
            [MobClick event:@"006"];
        }
    }
    else if(indexPath.section==2)
    {
        if(indexPath.row==0)
        {
            //我的资料
            MyInfoViewController *myInfo = KKViewControllerOfMainSB(@"MyInfoViewController");
            [self.navigationController pushViewController:myInfo animated:YES];
        }
        else if(indexPath.row==1)
        {
            //我的动态
            DynamicListViewController *dynamicList = KKViewControllerOfMainSB(@"DynamicListViewController");
            dynamicList.uidStr = @"0";
            dynamicList.showRightItem = YES;
            [self.navigationController pushViewController:dynamicList animated:YES];
            
        }
        else if(indexPath.row==2)
        {
            //我的相册
            MyPhotoViewController *myPhotoTVC=KKViewControllerOfMainSB(@"MyPhotoViewController");
            [self.navigationController pushViewController:myPhotoTVC animated:YES];
        }
    }
    else if(indexPath.section==3)
    {
        if(indexPath.row==0)
        {
            //征友条件
            PartnerConditionsViewController *partner = KKViewControllerOfMainSB(@"PartnerConditionsViewController");
            [self.navigationController pushViewController:partner animated:YES];
        }
        else if(indexPath.row==1)
        {
            //诚信星级
            HonestyViewController *honestVC=KKViewControllerOfMainSB(@"HonestyViewController");
            [self.navigationController pushViewController:honestVC animated:YES];
            
        }
        else if(indexPath.row==2)
        {
            //自定义招呼
            CustomHiViewController *customhiVC=KKViewControllerOfMainSB(@"CustomHiViewController");
            [self.navigationController pushViewController:customhiVC animated:YES];
        }
        else if(indexPath.row==3)
        {
            //在线客服
            KKWebViewController *webVC=[[KKWebViewController alloc] init];
            webVC.urlStr=ServiceInterfaceCustomCallCenter;
            webVC.navTitle=@"客服中心";
            webVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:webVC animated:YES];
        }
        else if(indexPath.row==4)
        {
            //设置
            SettingTableViewController *settingTVC=KKViewControllerOfMainSB(@"SettingTableViewController");
            [self.navigationController pushViewController:settingTVC animated:YES];
        }
    }
}

@end
