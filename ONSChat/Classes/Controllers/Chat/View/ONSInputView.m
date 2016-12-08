//
//  ONSInputView.m
//  ONSChat
//
//  Created by liujichang on 2016/12/5.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "ONSInputView.h"

@interface ONSInputView()<UITextViewDelegate>

@property(strong,nonatomic) UIButton *emoticonBtn;
@property(strong,nonatomic) UIButton *voiceBtn;

@end

@implementation ONSInputView


-(instancetype)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame])
    {
        self.backgroundColor=[UIColor groupTableViewBackgroundColor];
        
        UITextView *textview=[[UITextView alloc] initWithFrame:CGRectMake(10, 8, frame.size.width-100, 37)];
        textview.delegate=self;
        textview.font=[UIFont systemFontOfSize:17];
        self.textView=textview;
        [self addSubview:textview];
        
        ONSButtonPurple *btn=[ONSButtonPurple ONSButtonWithTitle:@"发送" frame:CGRectMake(frame.size.width-80, 8, 70, 35)];
        [btn addTarget:self action:@selector(sendText:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];

        UIButton *emioBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [emioBtn setImage:[UIImage imageNamed:@"ic_bq"] forState:UIControlStateNormal];
        [emioBtn setFrame:CGRectMake(10, 50, 35, 35)];
        [emioBtn addTarget:self action:@selector(EmoticonClick:) forControlEvents:UIControlEventTouchUpInside];
        emioBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin;
        self.emoticonBtn=emioBtn;
        [self addSubview:emioBtn];
        
        UIButton *voicebtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [voicebtn setImage:[UIImage imageNamed:@"ic_sound"] forState:UIControlStateNormal];
        [voicebtn setFrame:CGRectMake(70, 50, 35, 35)];
        [voicebtn addTarget:self action:@selector(VoiceClick:) forControlEvents:UIControlEventTouchUpInside];
        voicebtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin;
        self.voiceBtn=voicebtn;
        [self addSubview:voicebtn];
        
        UIButton *videoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [videoBtn setImage:[UIImage imageNamed:@"ic_video"] forState:UIControlStateNormal];
        [videoBtn setFrame:CGRectMake(130, 50, 35, 35)];
        [videoBtn addTarget:self action:@selector(VideoClick:) forControlEvents:UIControlEventTouchUpInside];
        videoBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:videoBtn];
        
        UIButton *imageBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [imageBtn setImage:[UIImage imageNamed:@"ic_pic"] forState:UIControlStateNormal];
        [imageBtn setFrame:CGRectMake(190, 50, 35, 35)];
        [imageBtn addTarget:self action:@selector(ImageClick:) forControlEvents:UIControlEventTouchUpInside];
        imageBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:imageBtn];
        
    }
    
    return self;
}

-(void)sendText:(id)sender{
    
    // 点击了发送按钮
    if(KKStringIsNotBlank(self.textView.text))
    {
        if([self isVIP])
        {
            CGRect selfFrame = KKFrameOfSizeH(self.frame, 90);
            selfFrame.origin.y = self.frame.origin.y + (self.bounds.size.height - 90.0);
            self.frame = selfFrame;
            
            self.textView.frame = KKFrameOfSizeH(self.textView.frame, 37.0);
            [_delegate inputView:self didEndEditingText:self.textView.text];
            [_delegate inputView:self didChangedHeigth:90.0];
            _textView.text = nil;
        }
    }
    
}

-(void)EmoticonClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    _voiceBtn.selected = NO;
    
    if (sender.selected) // 表情
        _state = ONSInputViewStateEmotion;
    else // 文字
        _state = ONSInputViewStateText;
    
    [self notifiDelegate];
}

-(void)VoiceClick:(UIButton *)sender{
    
   if([self isBaoYue])
   {
       sender.selected = !sender.selected;
       _emoticonBtn.selected = NO;
       
       if (sender.selected) // 录音
           _state = ONSInputViewStateVoice;
       else // 文字
           _state = ONSInputViewStateText;
       
       [self notifiDelegate];
   }
}

-(void)VideoClick:(id)sender{
    if([self isBaoYue])
    {
        if(_delegate) [_delegate inputViewClickVideo];

    }
}

-(void)ImageClick:(id)sender{
    if([self isBaoYue])
    {
        if(_delegate) [_delegate inputViewClickPhoto];

    }
}


#pragma mark - UITextVeiw delegate
- (void)textViewDidChange:(UITextView *)textView {
    
    [self calTextViewHeight];
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    
//    // 点击了发送按钮
//    if (StringsIsEquals(text, @"\n")) {
//        
//        if ([textView.text isMatchsRegex:@"^\\s+$"]) {
//            TTAlertNoMessage(@"不能发送空白消息");
//        } else {
//            CGRect selfFrame = RectChangeHeight(self, 50.0);
//            selfFrame.origin.y = self.frame.origin.y + (self.bounds.size.height - 50.0);
//            self.frame = selfFrame;
//            
//            textView.frame = RectChangeHeight(textView, 37.0);
//            [_delegate inputView:self didEndEditingText:textView.text];
//            [_delegate inputView:self didChangedHeigth:50.0];
//            _textView.text = nil;
//        }
//        
//        return NO;
//    }
//    
//    return YES;
//}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    _state = ONSInputViewStateText;
    return YES;
}


/** 切换输入状态后通知代理 */
- (void)notifiDelegate {
    [_delegate inputView:self stateChanged:_state];
}

/** 重置输入状态 */
- (void)resetState {
    NSLog(@"resetstate");
    _emoticonBtn.selected=NO;
    _voiceBtn.selected=NO;
    _state = ONSInputViewStateText;
}

-(void)calTextViewHeight
{
    NSLog(@"textcontentheight:%f",self.textView.contentSize.height);
    CGRect textViewFrame = KKFrameOfSizeH(self.textView.frame, self.textView.contentSize.height);
    if (textViewFrame.size.height > 100.0) {
        return;
    }
    self.textView.frame = textViewFrame;
    
    CGFloat selfHeight = textViewFrame.size.height + 55;
    CGRect selfFrame = KKFrameOfSizeH(self.frame, selfHeight);
    selfFrame.origin.y = self.frame.origin.y + (self.bounds.size.height - selfHeight);
    self.frame = selfFrame;
    
    [_delegate inputView:self didChangedHeigth:selfHeight];
}

-(BOOL)isBaoYue
{
    if(!KKSharedCurrentUser.isBaoYue)
    {
        NSString *str=@"您还没有开通包月写信功能哦，快去开通吧，很多美女都在等待你的回信呢!";
        [WCAlertView  showAlertWithTitle:@"温馨提示" message:str customizationBlock:nil completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            
            if(buttonIndex==1)
            {
                //去开通
                if(_delegate) [_delegate gotoBaoYue];
            }
            
        } cancelButtonTitle:@"下次再说" otherButtonTitles:@"开通", nil];
        return NO;
    }
    return YES;
}

-(BOOL)isVIP
{
    if(!KKSharedCurrentUser.isVIP)
    {
        NSArray *arr=@[@"干",@"草",@"约",@"炮",@"泡",@"日",@"爱爱",@"啪",@"床", @"飞机",@"视频",@"自慰", @"操",@"逼",@"脱",@"奶",@"做爱",@"开房",@"插",@"JB",@"鸡巴",@"一夜情",@"微信",@"V信",@"QQ",@"Q",@"电话",@"号码",@"VX",@"扣扣"];
        
        for (NSString *str in arr) {
            if([[self.textView.text uppercaseString] containsString:str])
            {
                NSString *msg=@"哥，升级VIP您就随便了";
                [WCAlertView  showAlertWithTitle:@"温馨提示" message:msg customizationBlock:nil completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                    
                    if(buttonIndex==1)
                    {
                        //去开通vip
                        if(_delegate) [_delegate gotoVIP];
                    }
                    
                } cancelButtonTitle:@"继续忍着" otherButtonTitles:@"升级VIP", nil];
                return NO;
            }
        }
        
    }
    return YES;
}

@end
