//
//  MessageCell.h
//  ONSChat
//
//  Created by liujichang on 2016/12/6.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import <UIKit/UIKit.h>




@class MessageCell;
@protocol MessageCellDelegate <NSObject>

/** 点击头像 */
-(void)messageCellTapHead:(ONSMessage*)message;

/** 去vip*/
-(void)messageGotoVip;


@end

@interface MessageCell : UITableViewCell

@property(strong,nonatomic) NSString *avaterUrl;
@property (strong, nonatomic) ONSMessage *message;
@property (weak, nonatomic) id<MessageCellDelegate> delegate;

//topview 可能是打招呼，系统推荐，附近的人
@property(weak,nonatomic) UIView *topView;

//时间label
@property(weak,nonatomic) UILabel *dateLabel;
/** 头像 */
@property (weak, nonatomic) UIButton *headButton;
/** 内容背景 */
@property (weak, nonatomic) UIButton *backgroundButton;


+(MessageCell*)cellWithTableView:(UITableView*)tableView message:(ONSMessage*)message avaterUrl:(NSString*)avaterurl delegate:(id<MessageCellDelegate>)delegate;



@end
