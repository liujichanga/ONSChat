//
//  ChatListCell.m
//  ONSChat
//
//  Created by liujichang on 2016/11/30.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "ChatListCell.h"
#import "JSBadgeView.h"


@interface ChatListCell()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *datetimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *chatInfoLabel;


@end

@implementation ChatListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //NSLog(@"chatlist awake");
    
    JSBadgeView *badgeview=[[JSBadgeView alloc] initWithParentView:self.headImageView alignment:JSBadgeViewAlignmentTopRight];
    badgeview.tag=102;
    badgeview.hidden=YES;
    badgeview.badgeBackgroundColor= KKColorPurple;
    badgeview.badgeTextColor= [UIColor whiteColor];
    badgeview.badgeTextShadowOffset=CGSizeZero;
    badgeview.badgeTextShadowColor=[UIColor clearColor];
    badgeview.badgeOverlayColor = [UIColor clearColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)displayInfo:(ONSConversation*)conversation
{
    _nickNameLabel.text=conversation.nickName;
    _ageLabel.text=KKStringWithFormat(@"%ld岁・%@市",conversation.age,KKSharedGlobalManager.GPSCity);
    
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:conversation.time];
    //NSLog(@"date:%@,currentdate:%@",date,[NSDate date]);
    if([date isEqualToDateIgnoringTime:[NSDate date]])
    {
        _datetimeLabel.text=[[NSDate dateWithTimeIntervalSince1970:conversation.time] stringTime];
    }
    else
    {
        _datetimeLabel.text=[[NSDate dateWithTimeIntervalSince1970:conversation.time] stringMonthDay];
    }
    
    _headImageView.image=[UIImage imageNamed:@"def_head"];
    if(KKStringIsNotBlank(conversation.avatar))
        KKImageViewWithUrlstring(_headImageView, conversation.avatar, @"def_head");
    
    UIView *view=[self.headImageView viewWithTag:102];
    NSAssert(view != nil, @"没有jsbadgeview");
    if(view)
    {
        JSBadgeView *badgeview=(JSBadgeView*)view;
        
        if(conversation.unReadCount>0)
        {
            badgeview.hidden=NO;
            badgeview.badgeText=KKStringWithFormat(@"%ld",conversation.unReadCount);
        }
        else
        {
            badgeview.hidden=YES;
        }
    }
    
    _chatInfoLabel.textColor=[UIColor darkGrayColor];
    _chatInfoLabel.attributedText=nil;
    _chatInfoLabel.text=nil;
    
    //显示聊天信息
    [ONSSharedMessageDao getMessageByMessageId:conversation.lastMessageId completion:^(id result) {
        
        if(result)
        {
            ONSMessage *message=(ONSMessage*)result;
            NSDictionary *dic=[message.content objectFromJSONString];
            switch (message.messageType) {
                case ONSMessageType_Text: // 文字内容
                case ONSMessageType_System:
                case ONSMessageType_Choice:
                case ONSMessageType_Recommand:
                case ONSMessageType_NearBy:
                    _chatInfoLabel.text=[dic stringForKey:@"content" defaultValue:@""];
                    break;
                    
                case ONSMessageType_NormImage:
                case ONSMessageType_LockImage:
                {
                    _chatInfoLabel.text=@"[图片]";
                    _chatInfoLabel.textColor=KKColorPurple;
                }
                    break;
                    
                case ONSMessageType_Video:
                {
                    _chatInfoLabel.text=@"[视频]";
                    _chatInfoLabel.textColor=KKColorPurple;
                }
                    break;
                    
                case ONSMessageType_Voice:
                {
                    _chatInfoLabel.text=@"[语音]";
                    _chatInfoLabel.textColor=KKColorPurple;
                }
                    break;
                    
                case ONSMessageType_WeChat:
                {
                    NSString *str=[dic stringForKey:@"content" defaultValue:@""];
                    NSArray *arr=[str componentsSeparatedByString:@"&-&"];
                    if(arr.count>1)
                    {
                        NSString *strcontent=[arr[0] stringByReplacingOccurrencesOfString:@"icon" withString:@""];
                        
                        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:strcontent];
                        
                        UIImage *img = [UIImage imageNamed:@"chat_wx"];
                        NSTextAttachment *textAttach = [[NSTextAttachment alloc]init];
                        textAttach.image = img;
                        
                        NSAttributedString * strA =[NSAttributedString attributedStringWithAttachment:textAttach];
                        [attri appendAttributedString:strA];
                        
                        _chatInfoLabel.attributedText = attri;
                    }
                    
                    
                }
                    break;
                    
                case ONSMessageType_Hi:
                {
                    NSString *str=[dic stringForKey:@"content" defaultValue:@""];
                    NSArray *arr=[str componentsSeparatedByString:@"&-&"];
                    if(arr.count>1)
                    {
                        _chatInfoLabel.text=arr[1];
                    }
                }
                    break;
                    
                    
                default:
                    break;
            }
        }
        
    } inBackground:YES];
    

}

@end
