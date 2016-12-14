//
//  ChatListViewController.m
//  ONSChat
//
//  Created by liujichang on 2016/11/20.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChatViewController.h"
#import "ChatListCell.h"
#import "JSBadgeView.h"
#import "ChatViewController.h"



#define cellChatListIdentifier @"ChatListCell"

@interface ChatListViewController ()

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *topTipView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property(strong,nonatomic) ONSConversation *systemConversation;
@property(strong,nonatomic) NSMutableArray *conversationList;

@end

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[_topTipView.layer setMasksToBounds:YES];
    //[_topTipView.layer setCornerRadius:3.0];
    _topView.layer.borderWidth=1.0;
    _topView.layer.borderColor=[UIColor groupTableViewBackgroundColor].CGColor;
    
    JSBadgeView *badgeview=[[JSBadgeView alloc] initWithParentView:self.topTipView alignment:JSBadgeViewAlignmentTopRight];
    badgeview.tag=102;
    badgeview.hidden=YES;
    badgeview.badgeBackgroundColor= KKColorPurple;
    badgeview.badgeTextColor= [UIColor whiteColor];
    badgeview.badgeTextShadowOffset=CGSizeZero;
    badgeview.badgeTextShadowColor=[UIColor clearColor];
    badgeview.badgeOverlayColor = [UIColor clearColor];

    UITapGestureRecognizer *systemTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(systemTap:)];
    [self.topView addGestureRecognizer:systemTapGestureRecognizer];
    
    _conversationList=[NSMutableArray array];
    
    //使用registerNib 方法可以从XIB加载控件
    [self.tableView registerNib:[UINib nibWithNibName:cellChatListIdentifier bundle:nil] forCellReuseIdentifier:cellChatListIdentifier];
    
    //添加会话，更新会话通知
    KKNotificationCenterAddObserverOfSelf(addConversation, ONSChatManagerNotification_AddConversation, nil);
    KKNotificationCenterAddObserverOfSelf(updateConversation, ONSChatManagerNotification_UpdateConversation, nil);

    [self getConversations];
   
}

-(void)dealloc
{
    KKNotificationCenterRemoveObserverOfSelf;
}

-(void)systemTap:(id)sender{
    
    ChatViewController *chatVC=KKViewControllerOfMainSB(@"ChatViewController");
    chatVC.targetId=@"0";
    chatVC.targetNickName=@"系统通知";
    [self.navigationController pushViewController:chatVC animated:YES];

    //更新未读数量
    _systemConversation.unReadCount=0;
    [ONSSharedConversationDao updateNoUnReadCountByTargetId:_systemConversation.targetId completion:nil inBackground:YES];
}

#pragma mark - ConversationNotification
-(void)addConversation
{
    [self getConversations];
}

-(void)updateConversation
{
    [self getConversations];
}

#pragma mark - 读取数据库中的数据
-(void)getConversations{
 
    KKWEAKSELF;
    
    //读取系统会话
    [ONSSharedConversationDao getConversationByTargetId:@"0" completion:^(id result) {
        
        if(result)
        {
            _systemConversation=(ONSConversation*)result;
            
            UIView *view=[weakself.topTipView viewWithTag:102];
            if(view)
            {
                JSBadgeView *badgeview=(JSBadgeView*)view;
                
                if(_systemConversation.unReadCount>0)
                {
                    badgeview.hidden=NO;
                    badgeview.badgeText=KKStringWithFormat(@"%ld",_systemConversation.unReadCount);
                }
                else
                {
                    badgeview.hidden=YES;
                }
            }
        }
        
    } inBackground:YES];
    

    //读取会话列表
    [ONSSharedConversationDao getConversationListCompletion:^(id result) {
        
        if(result)
        {
            [_conversationList removeAllObjects];
            NSArray *arr=(NSArray*)result;
            [_conversationList addObjectsFromArray:arr];
           
            [weakself.tableView reloadData];
        }
        
        
    } inBackground:YES];
    
    //读取系统未读总数
    [KKSharedONSChatManager getUnReadCount];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.conversationList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return KKScreenWidth/320.0*70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatListCell *cell=[tableView dequeueReusableCellWithIdentifier:cellChatListIdentifier forIndexPath:indexPath];

    if(self.conversationList.count>indexPath.row)
    {
        [cell displayInfo:self.conversationList[indexPath.row]];
    }
    
    return cell;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if(self.conversationList.count>indexPath.row)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        ONSConversation *conversation=self.conversationList[indexPath.row];
        
        ChatViewController *chatVC=KKViewControllerOfMainSB(@"ChatViewController");
        chatVC.targetId=conversation.targetId;
        chatVC.targetNickName=conversation.nickName;
        chatVC.targetIdAvaterUrl=conversation.avatar;
        [self.navigationController pushViewController:chatVC animated:YES];
        
        //更新未读数量
        conversation.unReadCount=0;
        [ONSSharedConversationDao updateNoUnReadCountByTargetId:conversation.targetId completion:nil inBackground:YES];
    }
    
}




@end
