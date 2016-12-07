//
//  RecommandMessageCell.m
//  ONSChat
//
//  Created by liujichang on 2016/12/6.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "RecommandMessageCell.h"

@interface RecommandMessageCell()

@property(weak,nonatomic) UILabel *titleContentLabel;

@property(weak,nonatomic) UILabel *textContentLabel;

@end

@implementation RecommandMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *titleContentLabel = [[UILabel alloc] init];
        titleContentLabel.numberOfLines = 1;
        titleContentLabel.font = [UIFont systemFontOfSize:16];
        titleContentLabel.textColor = [UIColor blackColor];
        titleContentLabel.textAlignment=NSTextAlignmentCenter;
        self.titleContentLabel = titleContentLabel;
        [self.contentView addSubview:titleContentLabel];
        
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
    
    
    self.titleContentLabel.text=@"来自\"系统智能匹配\"";
    self.titleContentLabel.frame=message.topViewFrame;
    
    // 文字
    self.textContentLabel.text=[message.contentJson stringForKey:@"content" defaultValue:@""];
    self.textContentLabel.frame = CGRectMake(10, 10, message.textSize.width, message.textSize.height);
}

@end
