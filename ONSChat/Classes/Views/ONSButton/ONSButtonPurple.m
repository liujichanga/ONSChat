//
//  ONSButtonPurple.m
//  ONSChat
//
//  Created by liujichang on 2016/11/25.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "ONSButtonPurple.h"

#define Radius  3.0

@implementation ONSButtonPurple

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
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:Radius];
    [self.layer setBorderWidth:1.0]; //边框宽度
    [self.layer setBorderColor:KKColorPurple.CGColor];//边框颜色
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if(!CGSizeEqualToSize(self.frame.size, CGSizeZero))
    {
        [self setBackgroundImage:[UIImage imageWithColor:KKColorPurple forSize:self.frame.size radius:Radius borderWidth:0 borderColor:nil] forState:UIControlStateNormal];

    }
}

+(instancetype)ONSButtonWithTitle:(NSString*)title frame:(CGRect)frame
{
    ONSButtonPurple *btn=[ONSButtonPurple buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    [btn setTitle:title forState:UIControlStateNormal];
    
    [btn setBackgroundImage:[UIImage imageWithColor:KKColorPurple forSize:btn.frame.size radius:Radius borderWidth:0 borderColor:nil] forState:UIControlStateNormal];
    
    return btn;
}

@end
