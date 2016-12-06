//
//  ONSEmoticonView.m
//  ONSChat
//
//  Created by liujichang on 2016/12/5.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "ONSEmoticonView.h"

@implementation EmoticonView

-(instancetype)initWithFrame:(CGRect)frame dic:(NSDictionary *)dic
{
    if(self=[super initWithFrame:frame])
    {
        UIImageView *imageview=[[UIImageView alloc] initWithImage:[UIImage imageNamed:[dic stringForKey:@"png" defaultValue:@""]]];
        imageview.frame=self.bounds;
        [self addSubview:imageview];
       
        self.userInteractionEnabled=YES;
        
        self.pngName=[dic stringForKey:@"png" defaultValue:@""];
        self.text=[dic stringForKey:@"chs" defaultValue:@""];
    }
    
    return self;
}

@end



@implementation ONSEmoticonView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame])
    {
        self.backgroundColor=[UIColor lightTextColor];
        [self loadEmotions];
    }
    
    return self;
}

-(void)loadEmotions
{
    NSArray *arr=KKSharedGlobalManager.emoticons;

    UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:scrollView];
    scrollView.backgroundColor=[UIColor clearColor];
    
    CGFloat imageViewWidth=35.0;
    CGFloat imageViewHeight=35.0;
    
    CGFloat widthInterval=10.0;
    CGFloat heightInterval=10.0;
    
    NSInteger numPerRow=(KKScreenWidth-widthInterval)/(imageViewWidth+widthInterval);
    NSInteger totalRow=arr.count/numPerRow;
    if(arr.count%numPerRow>0)
    {
        totalRow=totalRow+1;
    }
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, heightInterval+totalRow*(imageViewHeight+heightInterval))];

    for (int i=0; i<arr.count; i++) {
        NSDictionary *dic=arr[i];
        
        NSInteger v=i/numPerRow;
        NSInteger mod=i%numPerRow;
        CGFloat oringX=widthInterval+(imageViewWidth+widthInterval)*mod;
        CGFloat oringY=heightInterval+(imageViewHeight+heightInterval)*v;

        EmoticonView *emotionview=[[EmoticonView alloc] initWithFrame:CGRectMake(oringX, oringY, imageViewWidth, imageViewHeight) dic:dic];
        emotionview.tag=200+i;
        [scrollView addSubview:emotionview];

        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emoticonTap:)];
        [emotionview addGestureRecognizer:tapGestureRecognizer];

    }
  
}

-(void)emoticonTap:(UITapGestureRecognizer*)tapGestureRecognizer{
    
    EmoticonView *emoticonview=(EmoticonView*)tapGestureRecognizer.view;
    
    if(_delegate) [_delegate emoticonViewTap:emoticonview.pngName text:emoticonview.text];
}



@end
