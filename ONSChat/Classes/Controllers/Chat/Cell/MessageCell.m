//
//  MessageCell.m
//  ONSChat
//
//  Created by liujichang on 2016/12/6.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "MessageCell.h"
#import "TextMessageCell.h"
#import "ChoiceMessageCell.h"
#import "ImageMessageCell.h"
#import "VideoMessageCell.h"
#import "VoiceMessageCell.h"
#import "WeChatMessageCell.h"
#import "HiMessageCell.h"
#import "RecommandMessageCell.h"
#import "NearByMessageCell.h"



@implementation MessageCell

+(MessageCell *)cellWithTableView:(UITableView *)tableView message:(ONSMessage *)message delegate:(id<MessageCellDelegate>)delegate
{
    Class cellClass = nil;
    switch (message.messageType) {
        case ONSMessageType_Text: // 文字内容
        case ONSMessageType_System:
            cellClass = [TextMessageCell class];
            break;
            
        case ONSMessageType_Choice:
            cellClass=[ChoiceMessageCell class];
            break;
            
        case ONSMessageType_NormImage:
        case ONSMessageType_LockImage:
            cellClass=[ImageMessageCell class];
            break;
            
        case ONSMessageType_Video:
            cellClass=[VideoMessageCell class];
            break;
            
        case ONSMessageType_Voice:
            cellClass=[VoiceMessageCell class];
            break;
            
        case ONSMessageType_WeChat:
            cellClass=[WeChatMessageCell class];
            break;
            
        case ONSMessageType_Hi:
            cellClass=[HiMessageCell class];
            break;
            
        case ONSMessageType_Recommand:
            cellClass=[RecommandMessageCell class];
            break;
            
        case ONSMessageType_NearBy:
            cellClass=[NearByMessageCell class];
            break;
            
       
        default:
            break;
    }
    
    NSString *identifier = NSStringFromClass(cellClass);
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.delegate = delegate;
    }
    
    cell.message = message;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        

        //时间
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, KKScreenWidth, 20)];
        label.backgroundColor=[UIColor clearColor];
        label.font=[UIFont systemFontOfSize:14];
        label.textAlignment=NSTextAlignmentCenter;
        self.dateLabel=label;
        [self.contentView addSubview:label];
        
        // 头像
        UIButton *headPortraitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        headPortraitButton.userInteractionEnabled = NO;
        [headPortraitButton setBackgroundImage:[UIImage imageNamed:@"def_head"] forState:UIControlStateNormal];
        self.headButton = headPortraitButton;
        [self.contentView addSubview:headPortraitButton];
        
        // 内容背景
        UIButton *backgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //backgroundButton.adjustsImageWhenHighlighted = NO;
        backgroundButton.userInteractionEnabled = NO;
        self.backgroundButton = backgroundButton;
        [self.contentView addSubview:backgroundButton];
        
      
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setMessage:(ONSMessage *)message
{
    _message=message;
    
    
    self.backgroundButton.frame = message.backGroundButtonFrame;

    self.headButton.frame=message.headButtonFrame;
}

@end
