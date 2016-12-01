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


#define cellChatListIdentifier @"ChatListCell"

@interface ChatListViewController ()<RCIMClientReceiveMessageDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *topTipView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_topTipView.layer setMasksToBounds:YES];
    [_topTipView.layer setCornerRadius:3.0];
    _topView.layer.borderWidth=1.0;
    _topView.layer.borderColor=[UIColor groupTableViewBackgroundColor].CGColor;
    
    UITapGestureRecognizer *systemTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(systemTap:)];
    [self.topView addGestureRecognizer:systemTapGestureRecognizer];
    
    //使用registerNib 方法可以从XIB加载控件
    [self.tableView registerNib:[UINib nibWithNibName:cellChatListIdentifier bundle:nil] forCellReuseIdentifier:cellChatListIdentifier];
    
    // 设置消息接收监听
    [[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:self object:nil];
    
    NSArray *conversationList = [[RCIMClient sharedRCIMClient]
                                 getConversationList:@[@(ConversationType_PRIVATE),
                                                       @(ConversationType_DISCUSSION),
                                                       @(ConversationType_GROUP),
                                                       @(ConversationType_SYSTEM),
                                                       @(ConversationType_APPSERVICE),
                                                       @(ConversationType_PUBLICSERVICE)]];
    for (RCConversation *conversation in conversationList) {
        NSLog(@"会话类型：%lu，目标会话ID：%@", (unsigned long)conversation.conversationType, conversation.targetId);
        
       NSArray *arr = [[RCIMClient sharedRCIMClient] getLatestMessages:conversation.conversationType targetId:conversation.targetId count:100];
        for (RCMessage *message in arr) {
            NSLog(@"mesg:%@",message);
        }
        NSLog(@"arr:%zd,%@",arr.count,arr);
    }
}

-(void)systemTap:(id)sender{
    
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatListCell *cell=[tableView dequeueReusableCellWithIdentifier:cellChatListIdentifier forIndexPath:indexPath];

    [cell displayInfo];
    
    return cell;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
}

#pragma mark - RC
- (void)onReceived:(RCMessage *)message left:(int)nLeft object:(id)object {
    if ([message.content isMemberOfClass:[RCTextMessage class]]) {
        RCTextMessage *testMessage = (RCTextMessage *)message.content;
        NSLog(@"消息内容：%@", testMessage.content);
    }
    
    NSLog(@"还剩余的未接收的消息数：%d", nLeft);
    
    int totalUnreadCount = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
    NSLog(@"当前所有会话的未读消息数为：%d", totalUnreadCount);
    
    NSArray *conversationList = [[RCIMClient sharedRCIMClient]
                                 getConversationList:@[@(ConversationType_PRIVATE),
                                                       @(ConversationType_DISCUSSION),
                                                       @(ConversationType_GROUP),
                                                       @(ConversationType_SYSTEM),
                                                       @(ConversationType_APPSERVICE),
                                                       @(ConversationType_PUBLICSERVICE)]];
    for (RCConversation *conversation in conversationList) {
        NSLog(@"会话类型：%lu，目标会话ID：%@", (unsigned long)conversation.conversationType, conversation.targetId);
    }
}


@end
