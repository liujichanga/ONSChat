//
//  WeChatMessageCell.m
//  ONSChat
//
//  Created by liujichang on 2016/12/6.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "WeChatMessageCell.h"

@interface WeChatMessageCell()

@property(weak,nonatomic) UILabel *textContentLabel;

@end


@implementation WeChatMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
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
    
    NSString *str=[message.contentJson stringForKey:@"content" defaultValue:@""];
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
        
        self.textContentLabel.attributedText=attri;
        self.textContentLabel.frame = CGRectMake(10, 5, message.wechatSize.width, message.wechatSize.height);
    }
    // 文字
    
}

@end
