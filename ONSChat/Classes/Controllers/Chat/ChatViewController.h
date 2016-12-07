//
//  ChatViewController.h
//  ONSChat
//
//  Created by liujichang on 2016/11/20.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : KKBaseViewController


//聊天用户的avater
@property(strong,nonatomic) NSString *targetIdAvaterUrl;

//聊天用户的targeid
@property(strong,nonatomic) NSString *targetId;

//聊天用户的昵称
@property(strong,nonatomic) NSString *targetNickName;

@end
