//
//  VideoMessageCell.m
//  ONSChat
//
//  Created by liujichang on 2016/12/6.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "VideoMessageCell.h"

@interface VideoMessageCell()

@property (nonatomic, strong) KRVideoPlayerController *videoController;


@end

@implementation VideoMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        
    }
    return self;
}

- (void)setMessage:(ONSMessage *)message {
    [super setMessage:message];
    
    NSString *url=[message.contentJson stringForKey:@"content" defaultValue:@""];
    if(KKStringIsNotBlank(url))
    {
        if(![url hasPrefix:@"http"])
        {
            url = KKStringWithFormat(@"file://%@",url);
        }
        self.videoController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(2 ,5,message.videoSize.width,message.videoSize.height) andImageURL:nil andVideoURL:url];
        self.videoController.repeatMode = MPMovieRepeatModeNone;
        [self.videoController showInView:self.backgroundButton];

    }
    
    
}

@end
