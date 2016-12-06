//
//  WZMRecordView.h
//
//  Created by 王志明 on 14/12/26.
//  Copyright (c) 2014年 王志明. All rights reserved.
//
// 录音面板

#import <UIKit/UIKit.h>
@class WZMRecordView;

/** 录音组件代理 */
@protocol WZMRecordViewDelegate <NSObject>

- (void)recordView:(WZMRecordView *)recordView sendVoiceMessage:(NSString*)voicePath;

@end

@interface WZMRecordView : UIView

@property (weak, nonatomic) id<WZMRecordViewDelegate> delegate;

@property (assign, nonatomic, getter=isRecording) BOOL recording;

+ (instancetype)recordView;
- (void)cancelRecording;

@end
