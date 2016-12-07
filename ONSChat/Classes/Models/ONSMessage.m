//
//  ONSChat.m
//  ONSChat
//
//  Created by liujichang on 2016/12/1.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "ONSMessage.h"

@implementation ONSMessage

-(instancetype)initWithDic:(NSDictionary *)dic
{
     if (self = [super init])
     {
         _targetId=[dic stringForKey:@"fromid" defaultValue:@""];
         _messageType=[dic integerForKey:@"msgtype" defaultValue:1];
         _replyType=[dic integerForKey:@"replytype" defaultValue:1];
         NSDictionary *contentDic=[dic objectForKey:@"medirlist"];
         if(contentDic&&[contentDic isKindOfClass:[NSDictionary class]])
         {
             _content=[contentDic JSONString];
         }
         //_content=[dic stringForKey:@"medirlist" defaultValue:@""];

     }
    
    return self;
}

-(void)calLayout
{
    CGFloat originY=0;
    
    switch (_messageType) {
        case ONSMessageType_Hi:
        {
            NSString *str=[_contentJson stringForKey:@"content" defaultValue:@""];
            NSArray *arr=[str componentsSeparatedByString:@"&-&"];
            if(arr.count>1)
            {
                CGSize size=[arr[0] sizeWithFont:MessageFont maxSize:CGSizeMake(MessageContentMaxWidth-20, 1000)];
                _topViewFrame=CGRectMake(0, 0, KKScreenWidth, size.height+20);
            }
        }
            break;
            
        case ONSMessageType_Recommand:
            _topViewFrame=CGRectMake(0, 0, KKScreenWidth, 35);
            break;
            
        case ONSMessageType_NearBy:
            _topViewFrame=CGRectMake(0, 0, KKScreenWidth, 35);
            break;
            
        default:
            break;
    }
    
    originY=_topViewFrame.size.height+10;
    
    _dateLabelFrame=CGRectMake(0, originY, KKScreenWidth, 20);
    originY+=_dateLabelFrame.size.height+10;
    
    //头像frame
    _receiveHeadButtonFrame=CGRectMake(MessageInterval, originY, 40, 40);
    _sendHeadButtonFrame=CGRectMake(KKScreenWidth-MessageInterval-40, originY, 40, 40);
    
    switch (_messageType) {
        case ONSMessageType_NormImage:
        case ONSMessageType_LockImage:
        {
            _receiveBackGroundButtonFrame=CGRectMake(MessageBackgoundInterval, originY, self.imageSize.width+10, self.imageSize.height+10);
            _sendBackGroundButtonFrame=CGRectMake(KKScreenWidth-MessageBackgoundInterval-_receiveBackGroundButtonFrame.size.width, originY, self.imageSize.width+10, self.imageSize.height+10);
            
            originY+=_receiveBackGroundButtonFrame.size.height+10;
        }
            break;
            
        case ONSMessageType_Video:
        {
            _receiveBackGroundButtonFrame=CGRectMake(MessageBackgoundInterval, originY, self.videoSize.width+10, self.videoSize.height+10);
            _sendBackGroundButtonFrame=CGRectMake(KKScreenWidth-MessageBackgoundInterval-_receiveBackGroundButtonFrame.size.width, originY, self.videoSize.width+10, self.videoSize.height+10);
            
            originY+=_receiveBackGroundButtonFrame.size.height+10;
        }
            break;
        
        case ONSMessageType_Voice:
        {
            _receiveBackGroundButtonFrame=CGRectMake(MessageBackgoundInterval, originY, self.voiceSize.width+10, self.voiceSize.height+10);
            _sendBackGroundButtonFrame=CGRectMake(KKScreenWidth-MessageBackgoundInterval-_receiveBackGroundButtonFrame.size.width, originY, self.voiceSize.width+10, self.voiceSize.height+10);
            
            originY+=_receiveBackGroundButtonFrame.size.height+10;
        }
            break;
            
        case ONSMessageType_WeChat:
        {
            _receiveBackGroundButtonFrame=CGRectMake(MessageBackgoundInterval, originY, self.wechatSize.width+10, self.wechatSize.height+10);
            _sendBackGroundButtonFrame=CGRectMake(KKScreenWidth-MessageBackgoundInterval-_receiveBackGroundButtonFrame.size.width, originY, self.wechatSize.width+10, self.wechatSize.height+10);
            
            originY+=_receiveBackGroundButtonFrame.size.height+10;
        }
            break;
            
            
        default:
        {
            //计算文字大小
            _textSize=[self calTextContentSize];
            
            _receiveBackGroundButtonFrame=CGRectMake(MessageBackgoundInterval, originY, _textSize.width+20, _textSize.height+20);
            _sendBackGroundButtonFrame=CGRectMake(KKScreenWidth-MessageBackgoundInterval-_receiveBackGroundButtonFrame.size.width, originY, _textSize.width+20, _textSize.height+20);
            
            originY+=_receiveBackGroundButtonFrame.size.height+10;

        }
            break;
    }
    
    //选择题，额外加30
    if(_messageType==ONSMessageType_Choice)
    {
        originY+=30;
    }
    
    self.cellHeight=originY;
}

-(CGSize)calTextContentSize
{
    CGSize size=CGSizeZero;
    switch (_messageType) {
        case ONSMessageType_Text: // 文字内容
        case ONSMessageType_System:
        case ONSMessageType_Choice:
        case ONSMessageType_Recommand:
        case ONSMessageType_NearBy:
        {
            NSString *str=[_contentJson stringForKey:@"content" defaultValue:@""];
            size=[str sizeWithFont:MessageFont maxSize:CGSizeMake(MessageContentMaxWidth-20, 1000)];
            
        }
            break;
            
        case ONSMessageType_Hi:
        {
            NSString *str=[_contentJson stringForKey:@"content" defaultValue:@""];
            NSArray *arr=[str componentsSeparatedByString:@"&-&"];
            if(arr.count>1)
            {
                size=[arr[1] sizeWithFont:MessageFont maxSize:CGSizeMake(MessageContentMaxWidth-20, 1000)];
            }
        }
            break;
            
        default:
            break;
    }
    
    return size;
}


//图片大小
-(CGSize)imageSize{
    return CGSizeMake(KKScreenWidth-200, 200);
}
//视频大小
-(CGSize)videoSize{
    return CGSizeMake(KKScreenWidth-200, 200);
}
//微信大小
-(CGSize)wechatSize{
    return CGSizeMake(MessageContentMaxWidth-30, 30);
}
//声音大小
-(CGSize)voiceSize{
    return CGSizeMake(MessageContentMaxWidth-130, 30);
}



@end
