//
//  ONSInputView.h
//  ONSChat
//
//  Created by liujichang on 2016/12/5.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKTypeDefine.h"


@class ONSInputView;

@protocol ONSInputViewDelegate <NSObject>

/** 文本输入完毕 */
- (void)inputView:(ONSInputView *)inputView didEndEditingText:(NSString *)text;
/** 高度发生了变化 */
- (void)inputView:(ONSInputView *)inputView didChangedHeigth:(CGFloat)height;
/** 输入状态发生改变 */
- (void)inputView:(ONSInputView *)inputView stateChanged:(ONSInputViewState)state;

//点击选择视频
-(void)inputViewClickVideo;
//点击选择图片
-(void)inputViewClickPhoto;

@end


@interface ONSInputView : UIView


/** 文本输入框 */
@property (weak, nonatomic) UITextView *textView;

@property (assign, nonatomic, readonly) ONSInputViewState state;
@property (weak, nonatomic) id<ONSInputViewDelegate> delegate;

/** 重置输入状态 */
- (void)resetState;

-(void)calTextViewHeight;

@end
