//
//  ChoiceMessageCell.m
//  ONSChat
//
//  Created by liujichang on 2016/12/6.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "ChoiceMessageCell.h"

@interface ChoiceMessageCell()

@property(weak,nonatomic) UILabel *textContentLabel;

@property(weak,nonatomic) UILabel *bottomContentLabel;

@end

@implementation ChoiceMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *textContentLabel = [[UILabel alloc] init];
        textContentLabel.numberOfLines = 0;
        textContentLabel.font = MessageFont;
        textContentLabel.textColor = [UIColor blackColor];
        self.textContentLabel = textContentLabel;
        [self.backgroundButton addSubview:textContentLabel];
        
        UILabel *bottomContentLabel = [[UILabel alloc] init];
        bottomContentLabel.numberOfLines = 1;
        bottomContentLabel.font = [UIFont systemFontOfSize:17];
        bottomContentLabel.textColor = [UIColor darkGrayColor];
        bottomContentLabel.frame=CGRectMake(0, 0, KKScreenWidth, 20);
        bottomContentLabel.textAlignment=NSTextAlignmentCenter;
        bottomContentLabel.text=@"TA设置了最关心的问题需要你回答哦!";
        self.bottomContentLabel=bottomContentLabel;
        [self.contentView addSubview:bottomContentLabel];
        
    }
    return self;
}

- (void)setMessage:(ONSMessage *)message {
    [super setMessage:message];
    
    
    // 文字
    self.textContentLabel.text=[message.contentJson stringForKey:@"content" defaultValue:@""];
    
    self.textContentLabel.frame = CGRectMake(10, 10, message.textSize.width, message.textSize.height);
    
    self.bottomContentLabel.frame=KKFrameOfOriginY(self.bottomContentLabel.frame, CGRectGetMaxY(self.backgroundButton.frame)+10);
}

@end
