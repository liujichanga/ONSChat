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
    NSLog(@"date:%@,currentdate:%@",date,[NSDate date]);
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
        
    
    _chatInfoLabel.text=@"hi，你好，可以认识你妈";
}

@end
