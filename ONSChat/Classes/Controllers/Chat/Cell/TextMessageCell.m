//
//  TextMessageCell.m
//  ONSChat
//
//  Created by liujichang on 2016/12/6.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "TextMessageCell.h"

@interface TextMessageCell()

@property(weak,nonatomic) UILabel *textContentLabel;

@end

@implementation TextMessageCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *textContentLabel = [[UILabel alloc] init];
        textContentLabel.numberOfLines = 0;
        textContentLabel.font = MessageFont;
        textContentLabel.textColor = [UIColor blackColor];
        self.textContentLabel = textContentLabel;
        [self.contentView addSubview:textContentLabel];
    }
    return self;
}

- (void)setMessage:(ONSMessage *)message {
    [super setMessage:message];
    
    // 背景图片
    UIImage *normalImage = nil;
    if (message.messageDirection==ONSMessageDirection_SEND) {
        normalImage = [UIImage resizableImage:@"chatto_bg_normal.9" leftCap:15 topCap:25];
        //self.textContentLabel.textColor = [UIColor blackColor];
    } else {
        normalImage = [UIImage resizableImage:@"chatfrom_bg_normal.9" leftCap:15 topCap:25];
        //self.textContentLabel.textColor = [UIColor whiteColor];
    }
    [self.backgroundButton setBackgroundImage:normalImage forState:UIControlStateNormal];
    
    // 文字
//    if (message.attributedString) {
//        self.textContentLabel.attributedText = message.attributedString;
//    } else {
//        self.textContentLabel.text = message.textContent;
//    }
//    self.textContentLabel.frame = message.textContentFrame;
}

@end
