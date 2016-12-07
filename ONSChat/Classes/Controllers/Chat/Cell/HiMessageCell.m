//
//  HiMessageCell.m
//  ONSChat
//
//  Created by liujichang on 2016/12/6.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "HiMessageCell.h"

@interface HiMessageCell()

/** 头像 */
@property (weak, nonatomic) UIButton *hiHeadButton;
/** 内容背景 */
@property (weak, nonatomic) UIButton *hiBackgroundButton;

@property(weak,nonatomic) UILabel *hiTextContentLabel;


@property(weak,nonatomic) UILabel *textContentLabel;



@end

@implementation HiMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 头像
        UIButton *hiheadPortraitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        hiheadPortraitButton.userInteractionEnabled = NO;
        [hiheadPortraitButton setBackgroundImage:[UIImage imageNamed:@"def_head"] forState:UIControlStateNormal];
        self.hiHeadButton = hiheadPortraitButton;
        [self.contentView addSubview:hiheadPortraitButton];
        
        // 内容背景
        UIButton *hibackgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        hibackgroundButton.userInteractionEnabled = NO;
        self.hiBackgroundButton = hibackgroundButton;
        [self.hiBackgroundButton setBackgroundImage:[UIImage resizableImage:@"chatto_bg_normal.9" leftCap:15 topCap:25] forState:UIControlStateNormal];
        [self.contentView addSubview:hibackgroundButton];
        
        UILabel *hitextContentLabel = [[UILabel alloc] init];
        hitextContentLabel.numberOfLines = 0;
        hitextContentLabel.font = MessageFont;
        hitextContentLabel.textColor = [UIColor blackColor];
        self.hiTextContentLabel = hitextContentLabel;
        [self.hiBackgroundButton addSubview:hitextContentLabel];

        
        UILabel *textContentLabel = [[UILabel alloc] init];
        textContentLabel.numberOfLines = 0;
        textContentLabel.font = MessageFont;
        textContentLabel.textColor = [UIColor blackColor];
        self.textContentLabel = textContentLabel;
        [self.backgroundButton addSubview:textContentLabel];
    }
    return self;
}

- (void)setMessage:(ONSMessage *)message {
    [super setMessage:message];
    
    if(KKStringIsNotBlank(KKSharedCurrentUser.avatarUrl))
    {
        [self.hiHeadButton sd_setBackgroundImageWithURL:[NSURL fileURLWithPath:KKSharedCurrentUser.avatarUrl] forState:UIControlStateNormal];
    }
    self.hiHeadButton.frame=KKFrameOfOriginY(message.sendHeadButtonFrame, 10);
    
    //背景
    [self.hiBackgroundButton setBackgroundImage:[UIImage resizableImage:@"chatto_bg_normal.9" leftCap:15 topCap:25] forState:UIControlStateNormal];
    
    // 文字
    NSString *str=[message.contentJson stringForKey:@"content" defaultValue:@""];
    NSArray *arr=[str componentsSeparatedByString:@"&-&"];
    if(arr.count>1)
    {
        self.hiTextContentLabel.text=arr[0];
        CGSize size=[arr[0] sizeWithFont:MessageFont maxSize:CGSizeMake(MessageContentMaxWidth-20, 1000)];
        self.hiTextContentLabel.frame = CGRectMake(10, 10, size.width, size.height);

        self.textContentLabel.text=arr[1];
        self.textContentLabel.frame = CGRectMake(10, 10, message.textSize.width, message.textSize.height);
        

        self.hiBackgroundButton.frame = CGRectMake(KKScreenWidth-MessageBackgoundInterval-message.receiveBackGroundButtonFrame.size.width, 10, size.width+20, size.height+20);
    }
    
}

@end
