//
//  ONSButton.m
//  ONSChat
//
//  Created by liujichang on 2016/11/21.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "ONSButton.h"

@implementation ONSButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
        
    }
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self buttonCustom];
}

-(void)buttonCustom
{
    CGFloat radius = 3.0;
    
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:radius];
    [self.layer setBorderWidth:1.0]; //边框宽度
    [self.layer setBorderColor:KKColorPurple.CGColor];//边框颜色
    
    [self setTitleColor:KKColorPurple forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [self setBackgroundImage:[UIImage imageWithColor:KKColorPurple forSize:self.frame.size radius:radius borderWidth:0 borderColor:nil] forState:UIControlStateHighlighted];
    
}

+(instancetype)ONSButtonWithTitle:(NSString*)title
{
    ONSButton *btn=[self buttonWithType:UIButtonTypeCustom];
    [btn buttonCustom];
    
    return btn;
}

@end