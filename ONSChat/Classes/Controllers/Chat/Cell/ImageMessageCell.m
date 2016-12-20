//
//  ImageMessageCell.m
//  ONSChat
//
//  Created by liujichang on 2016/12/6.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "ImageMessageCell.h"

@interface ImageMessageCell()

@property(weak,nonatomic) UIImageView *bigImageView;

@end

@implementation ImageMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView *imageview=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"def_head"]];
        imageview.contentMode=UIViewContentModeScaleAspectFill;
        imageview.clipsToBounds=YES;
        self.bigImageView=imageview;
        [self.backgroundButton addSubview:imageview];
        
    }
    return self;
}

- (void)setMessage:(ONSMessage *)message {
    [super setMessage:message];
    
    NSString *url=[message.contentJson stringForKey:@"content" defaultValue:@""];
    if(KKStringIsNotBlank(url))
    {
        if([url hasPrefix:@"http"])
        {
            KKImageViewWithUrlstring(_bigImageView, url, @"def_head");
        }
        else
        {
            [_bigImageView sd_setImageWithURL:[NSURL fileURLWithPath:url] placeholderImage:[UIImage imageNamed:@"def_head"]];
        }
    }
    CGFloat orignx=7;
    if (message.messageDirection==ONSMessageDirection_SEND){
        orignx=3;
    }
    self.bigImageView.frame=CGRectMake(orignx, 5, message.imageSize.width, message.imageSize.height);

}


@end
