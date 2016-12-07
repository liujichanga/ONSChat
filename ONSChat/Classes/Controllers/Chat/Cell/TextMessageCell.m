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
        [self.backgroundButton addSubview:textContentLabel];
        

    }
    return self;
}

- (void)setMessage:(ONSMessage *)message {
    [super setMessage:message];
    
    
    // 文字
    self.textContentLabel.attributedText=[NSString showFace:[message.contentJson stringForKey:@"content" defaultValue:@""]];

    self.textContentLabel.frame = CGRectMake(10, 10, message.textSize.width, message.textSize.height);
}



@end
