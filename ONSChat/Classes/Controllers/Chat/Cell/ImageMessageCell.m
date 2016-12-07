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
        KKImageViewWithUrlstring(_bigImageView, url, @"def_head");
    }
    
    self.bigImageView.frame=CGRectMake(10, 5, message.imageSize.width, message.imageSize.height);

}


@end
