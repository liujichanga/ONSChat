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
        textContentLabel.minimumScaleFactor=0.5;
        textContentLabel.adjustsFontSizeToFitWidth=YES;
        self.textContentLabel = textContentLabel;
        [self.backgroundButton addSubview:textContentLabel];
        
        [self.backgroundButton addTarget:self action:@selector(wxClick:) forControlEvents:UIControlEventTouchUpInside];

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
    
}

-(void)wxClick:(id)sender{
    
    
    NSString *str=[self.message.contentJson stringForKey:@"content" defaultValue:@""];
    NSArray *arr=[str componentsSeparatedByString:@"&-&"];
    if(arr.count>1)
    {
        self.textContentLabel.text=arr[1];
    }

}

@end
