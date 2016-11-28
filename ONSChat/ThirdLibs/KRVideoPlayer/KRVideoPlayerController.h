//
//  KRVideoPlayerController.h
//  KRKit
//
//  Created by aidenluo on 5/23/15.
//  Copyright (c) 2015 36kr. All rights reserved.
//

@import MediaPlayer;

@interface KRVideoPlayerController : MPMoviePlayerController

@property (nonatomic, copy)void(^dimissCompleteBlock)(void);
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, strong) NSArray *videoURLs;
@property (nonatomic, assign) int indexNub;
@property (nonatomic, copy)  void(^shareBlock)();

- (instancetype)initWithFrame:(CGRect)frame;

- (void)showInWindow;
- (void)showInView:(UIView*)view;
- (void)dismiss;
-(void)leftBtnClick;
-(void)rightBtnClick;
@end
