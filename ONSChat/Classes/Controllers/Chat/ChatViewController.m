//
//  ChatViewController.m
//  ONSChat
//
//  Created by liujichang on 2016/11/20.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "ChatViewController.h"
#import "ONSInputView.h"
#import "WZMRecordView.h"
#import "ONSEmoticonView.h"
#import "MessageCell.h"
#import "VideoListViewController.h"
#import <Photos/Photos.h>
#import "ONSWaitReplyView.h"
#import "AnswerView.h"
#import "VIPPayViewController.h"
#import "BaoYuePayViewController.h"
#import "RecommendUserInfoViewController.h"
#import "IQKeyboardManager.h"



@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource,ONSInputViewDelegate,WZMRecordViewDelegate,ONSEmoticonViewDelegate,MessageCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AnswerViewDelegate>

@property (weak, nonatomic) UITableView *tableView;

@property(strong,nonatomic) ONSInputView *onsInputView;

/** 录音组件 */
@property (weak, nonatomic) WZMRecordView *recordView;
/** 表情面板 */
@property (weak, nonatomic) ONSEmoticonView *emotionView;
/**等待回复**/
@property(weak,nonatomic) ONSWaitReplyView *waitReplyView;

/** 是否正在退出当前界面 */
@property (assign, nonatomic) BOOL quiting;

//聊天的数组
@property(strong,nonatomic) NSMutableArray *messages;

//会话
@property(strong,nonatomic) ONSConversation *conversation;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor=KKColorFromRGB(0xF2F2F2);
    
    
    _messages=[NSMutableArray array];
    
    self.navigationItem.title=self.targetNickName;
    
    //UITableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.backgroundColor = KKColorFromRGB(0xF2F2F2);
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    // 输入组件
    ONSInputView *toolView = [[ONSInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-90, KKScreenWidth, 90)];
    toolView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    toolView.delegate = self;
    _onsInputView = toolView;
    _onsInputView.hidden=YES;
    _onsInputView.targetId=self.targetId;
    [self.view addSubview:_onsInputView];
    [self setTableViewBottomInset:0.0];

    //等待回复
    ONSWaitReplyView *waitreply=[[ONSWaitReplyView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, KKScreenWidth, 50)];
    self.waitReplyView=waitreply;
    _waitReplyView.hidden=YES;
    [self.view addSubview:self.waitReplyView];
    
    
    // 单击TableView隐藏键盘
    [self.tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)]];
    [self.tableView.panGestureRecognizer addTarget:self action:@selector(dismissKeyboard)];
    // 监听键盘
    KKNotificationCenterAddObserverOfSelf(dealKeyboard:, UIKeyboardWillChangeFrameNotification, nil)
    
    
    KKNotificationCenterAddObserverOfSelf(loadMessages, ONSChatManagerNotification_AddMessage, nil);

    [self loadMessages];

}

#pragma mark - Private
-(void)loadMessages{
    
    _onsInputView.hidden=YES;
    _waitReplyView.hidden=YES;
    KKLog(@"targetid:%@",self.targetId);
    KKWEAKSELF;
    [ONSSharedMessageDao getMessageListByTargetId:self.targetId Completion:^(id result) {
        
        [_messages removeAllObjects];
        if(result)
        {
            NSArray *arr=(NSArray*)result;
            for (ONSMessage *message in arr) {
                [message calLayout];
            }
            [weakself.messages addObjectsFromArray:arr];
            [weakself reloadDataAndScrollToBottom:YES];
            
            ONSMessage *lastMessage=(ONSMessage*)weakself.messages.lastObject;
            if(lastMessage.messageType==ONSMessageType_System)
            {
                return;
            }
            else if(lastMessage.messageType==ONSMessageType_Choice)
            {
                AnswerView *answerview=[[AnswerView alloc] initWithAnswer:lastMessage.contentJson];
                [weakself.view addSubview:answerview];
                answerview.targetId=self.targetId;
                answerview.delegate=self;
            }
            
            if(lastMessage.replyType!=ONSReplyType_Normal)
            {
                //显示等待回复
                _waitReplyView.hidden=NO;
                [weakself setTableViewBottomInset:0.0];
            }
            else
            {
                _onsInputView.hidden=NO;
                [weakself setTableViewBottomInset:0.0];
            }
        }
        
    } inBackground:YES];
    
    //读取当前会话
    [ONSSharedConversationDao getConversationByTargetId:self.targetId completion:^(id result) {
        if(result)
        {
            self.conversation=(ONSConversation*)result;
        }
    } inBackground:YES];
}

/** 设置TableView的底部内边距 */
- (void)setTableViewBottomInset:(CGFloat)bottomInset {
    UIEdgeInsets inset = self.tableView.contentInset;
    //    if ([UINavigationBar appearance].isTranslucent) {
    inset.top = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    //    }
    inset.bottom=bottomInset;
    if(!_onsInputView.hidden)
    {
        inset.bottom+=_onsInputView.frame.size.height;
    }
    if(!_waitReplyView.hidden)
    {
        inset.bottom+=_waitReplyView.frame.size.height;
    }
    //inset.bottom = _onsInputView.frame.size.height + bottomInset;
    self.tableView.contentInset = inset;
    self.tableView.scrollIndicatorInsets = inset;
    NSLog(@"isnert:%@",NSStringFromUIEdgeInsets(inset));
    [self scrollToBottom:YES];
}
/** 刷新TableView&滚动到底部 */
- (void)reloadDataAndScrollToBottom:(BOOL)animated {
    [self.tableView reloadData];
    [self scrollToBottom:animated];
}

/** 使TableView滚动到底部 */
- (void)scrollToBottom:(BOOL)animated {
    if(_messages.count) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_messages.count - 1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}


#pragma mark - WZMInputView delegate
/** 文本内容输入完成 */
- (void)inputView:(ONSInputView *)inputView didEndEditingText:(NSString *)text {
    
    //可以发送
    NSDictionary *med=@{@"content":text};
    NSDictionary *dic=@{@"fromid":self.targetId,@"avatar":self.targetIdAvaterUrl,@"nickname":self.targetNickName,@"age":@(self.targetAge),@"msgtype":@(ONSMessageType_Text),@"replytype":@(ONSReplyType_Normal),@"medirlist":med};
    
    [KKSharedONSChatManager sendMessage:dic];
    
    [MobClick event:self.conversation.esendtxtevent];
}

/** InputView高度发成变化 */
- (void)inputView:(ONSInputView *)inputView didChangedHeigth:(CGFloat)height {
    CGFloat inset = self.view.bounds.size.height - CGRectGetMaxY(inputView.frame);
    [self setTableViewBottomInset:inset];
}

/** 切换输入类型 */
- (void)inputView:(ONSInputView *)inputView stateChanged:(ONSInputViewState)state {
    if (state != ONSInputViewStateText) { // 隐藏键盘
        [_onsInputView endEditing:YES];
    }
    
    if (state == ONSInputViewStateVoice) { // 录音面板
        if (_emotionView)
            [self showOrHiddenEmotionView:YES moveInputView:NO];
        [self showOrHiddenRecordView:NO moveInputView:YES];
    } else if (state == ONSInputViewStateEmotion) { // 表情面板
        if (_recordView)
            [self showOrHiddenRecordView:YES moveInputView:NO];
        [self showOrHiddenEmotionView:NO moveInputView:YES];
    } else { // 其它
        if (_recordView) [self showOrHiddenRecordView:YES moveInputView:YES];
        if (_emotionView) [self showOrHiddenEmotionView:YES moveInputView:YES];
    }
}

/**点击选择视频**/
-(void)inputViewClickVideo
{
    KKWEAKSELF
    VideoListViewController *videoList = KKViewControllerOfMainSB(@"VideoListViewController");
    videoList.selectBlock = ^(PHAsset *asset){
        [weakself selectVideo:asset];
    };
    UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:videoList];
    [self presentViewController:navController animated:YES completion:nil];

}

/**点击选择图片**/
-(void)inputViewClickPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setValue:@(UIStatusBarStyleLightContent) forKey:@"_previousStatusBarStyle"];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

/** 去开通包月**/
-(void)inputGotoBaoYue
{
    BaoYuePayViewController *baoyueVC=KKViewControllerOfMainSB(@"BaoYuePayViewController");
    [self.navigationController pushViewController:baoyueVC animated:YES];
    
    KKLog(@"evelt:%@",self.conversation.ebillevent);
    [MobClick event:self.conversation.ebillevent];
}

/** 去开通vip**/
-(void)inputGotoVIP
{
    VIPPayViewController *vipVC=KKViewControllerOfMainSB(@"VIPPayViewController");
    [self.navigationController pushViewController:vipVC animated:YES];
    
    [MobClick event:self.conversation.ebillevent];
}

//显示本地视频列表
-(void)showVideoList{
    
    KKWEAKSELF
    VideoListViewController *videoList = KKViewControllerOfMainSB(@"VideoListViewController");
    videoList.selectBlock = ^(PHAsset *asset){
        [weakself selectVideo:asset];
    };
    UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:videoList];
    [self presentViewController:navController animated:YES completion:nil];
}

//处理所选视频
-(void)selectVideo:(PHAsset*)asset{
    
    PHImageManager *imgManager = [PHImageManager defaultManager];
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc]init];
    //获取视频
    [imgManager requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        KKLog(@"%@",asset);
        AVURLAsset *videoAsset = (AVURLAsset*)asset;
        
        long long int timestamp = [NSDate date].timeIntervalSince1970 * 1000 + arc4random()%1000;
        NSString *imagename=KKStringWithFormat(@"%lld.mp4",timestamp);
        NSString *path = [CacheUserPath stringByAppendingPathComponent:imagename];
        
        NSURL *videoURL = videoAsset.URL;
        NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
        
        BOOL result = [videoData writeToFile:path atomically:YES];
        
        if(result)
        {
            NSDictionary *med=@{@"content":path};
            NSDictionary *dic=@{@"fromid":self.targetId,@"avatar":self.targetIdAvaterUrl,@"nickname":self.targetNickName,@"age":@(self.targetAge),@"msgtype":@(ONSMessageType_Video),@"replytype":@(ONSReplyType_Normal),@"medirlist":med};
            
            [KKSharedONSChatManager sendMessage:dic];
        }
    }];
}

#pragma mark - UIImagePickDelegate
/** 获取到图片后进入这里 */
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // 关闭Picker
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 原图
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    long long int timestamp = [NSDate date].timeIntervalSince1970 * 1000 + arc4random()%1000;
    NSString *imagename=KKStringWithFormat(@"%lld.jpg",timestamp);
    NSString *path = [CacheUserPath stringByAppendingPathComponent:imagename];
    
    NSData *imagedata=UIImageJPEGRepresentation(image, 0.75);
    
    BOOL result = [imagedata writeToFile:path atomically:YES];
    
    if(result)
    {
        NSDictionary *med=@{@"content":path};
        NSDictionary *dic=@{@"fromid":self.targetId,@"avatar":self.targetIdAvaterUrl,@"nickname":self.targetNickName,@"age":@(self.targetAge),@"msgtype":@(ONSMessageType_NormImage),@"replytype":@(ONSReplyType_Normal),@"medirlist":med};
        
        [KKSharedONSChatManager sendMessage:dic];
        
    }
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - AnswerViewDelegate
-(void)answerViewTap:(NSString *)answer
{
    //可以发送
    NSDictionary *med=@{@"content":answer};
    NSDictionary *dic=@{@"fromid":self.targetId,@"avatar":self.targetIdAvaterUrl,@"nickname":self.targetNickName,@"age":@(self.targetAge),@"msgtype":@(ONSMessageType_Text),@"replytype":@(ONSReplyType_Contact),@"medirlist":med};
    
    [KKSharedONSChatManager sendMessage:dic];
    
}

-(void)answerGotoBaoYue
{
    BaoYuePayViewController *baoyueVC=KKViewControllerOfMainSB(@"BaoYuePayViewController");
    [self.navigationController pushViewController:baoyueVC animated:YES];
    
    [MobClick event:self.conversation.esendtxtevent];
}


#pragma mark - 键盘处理
- (void)dealKeyboard:(NSNotification *)note {
    
    // 正在推出界面
    if (_quiting) {
        return;
    }
    
    UIViewAnimationCurve curve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    // 键盘的动画时间
    NSTimeInterval duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的Frame
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //NSLog(@"defautl keyboardfrmae :%@",NSStringFromCGRect(keyboardFrame));

    // 处理键盘
    __block CGFloat delta =  keyboardFrame.origin.y == KKScreenHeight ? 0.0 : keyboardFrame.size.height;
    if (duration == 0.0) {
        duration = 0.25;
    }
    
    //NSLog(@"keyboardfrmae :%@",NSStringFromCGRect(keyboardFrame));
    
    // 弹出键盘时需要隐藏其它面板
    if (keyboardFrame.origin.y != KKScreenHeight) {
//        if (_onsInputView.state == ONSInputViewStateVoice) {
//            [self showOrHiddenRecordView:YES moveInputView:NO];
//            [_onsInputView resetState];
//        } else if (_onsInputView.state == ONSInputViewStateEmotion) {
//            [self showOrHiddenEmotionView:YES moveInputView:NO];
//            [_onsInputView resetState];
//        }
        
        [self showOrHiddenRecordView:YES moveInputView:NO];
        [self showOrHiddenEmotionView:YES moveInputView:NO];
        [_onsInputView resetState];
    }
    
    if (_onsInputView.state == ONSInputViewStateText) {
        [UIView animateWithDuration:duration animations:^{
            
            [UIView setAnimationCurve:curve];
            
            CGAffineTransform transform = CGAffineTransformMakeTranslation(0.0, -delta);
            _onsInputView.transform = transform;
            KKLog(@"delta : %f", delta);
            
            //            CGFloat y = Height(self.view) + -delta - Height(_toolView);
            //            _toolView.frame = RectChangeY(_toolView, y);
            
            [self setTableViewBottomInset:delta];
        }];
    }
}

/** 显示或隐藏录音组件 */
- (void)showOrHiddenRecordView:(BOOL)hidden moveInputView:(BOOL)moveInputView {
    if (hidden) {
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame = _recordView.frame;
            frame.origin.y = self.view.bounds.size.height;
            _recordView.frame = frame;
            
            if (moveInputView) {
                _onsInputView.transform = CGAffineTransformIdentity;
                [self setTableViewBottomInset:0.0];
            }
        } completion:^(BOOL finished) {
            [_recordView removeFromSuperview];
        }];
    } else {
        WZMRecordView *recordView = [WZMRecordView recordView];
        __block CGRect frame = recordView.bounds;
        frame.origin.y = self.view.bounds.size.height;
        frame.size.width = self.view.bounds.size.width;
        recordView.frame = frame;
        recordView.delegate = self;
        _recordView = recordView;
        [self.view addSubview:recordView];
        
        [UIView animateWithDuration:0.25 animations:^{
            frame.origin.y -= frame.size.height;
            recordView.frame = frame;
            
            if (moveInputView) {
                _onsInputView.transform = CGAffineTransformMakeTranslation(0.0, -frame.size.height);
                [self setTableViewBottomInset:frame.size.height];
            }
        }];
    }
}

/** 显示隐藏表情面板 */
- (void)showOrHiddenEmotionView:(BOOL)hidden moveInputView:(BOOL)moveInputView {
    if (hidden) {
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame = _emotionView.frame;
            frame.origin.y = self.view.bounds.size.height;
            _emotionView.frame = frame;
            
            if (moveInputView) {
                _onsInputView.transform = CGAffineTransformIdentity;
                [self setTableViewBottomInset:0.0];
            }
        } completion:^(BOOL finished) {
            [_emotionView removeFromSuperview];
        }];
    } else {
        ONSEmoticonView *emoView = [[ONSEmoticonView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-200, KKScreenWidth, 200)];
        __block CGRect frame = emoView.bounds;
        frame.origin.y =self.view.frame.size.height;
        frame.size.width =self.view.frame.size.width;
        emoView.frame = frame;
        emoView.delegate = self;
        _emotionView = emoView;
        [self.view addSubview:_emotionView];
        
        [UIView animateWithDuration:0.25 animations:^{
            frame.origin.y -= frame.size.height;
            _emotionView.frame = frame;
            
            if (moveInputView) {
                _onsInputView.transform = CGAffineTransformMakeTranslation(0.0, -frame.size.height);
                [self setTableViewBottomInset:frame.size.height];
            }
        }];
    }
}

/** 隐藏键盘 */
- (void)dismissKeyboard {
    if (_onsInputView.state == ONSInputViewStateVoice) {
        [self showOrHiddenRecordView:YES moveInputView:YES];
        [_onsInputView resetState];
    } else if (_onsInputView.state == ONSInputViewStateEmotion) {
        [self showOrHiddenEmotionView:YES moveInputView:YES];
        [_onsInputView resetState];
    } else {
        [_onsInputView endEditing:YES];
    }
}

#pragma mark - WZMRecordViewDelegate
-(void)recordView:(WZMRecordView *)recordView sendVoiceMessage:(NSString *)voicePath
{
    NSLog(@"voicepath delegate:%@",voicePath);
    NSDictionary *med=@{@"content":voicePath};
    NSDictionary *dic=@{@"fromid":self.targetId,@"avatar":self.targetIdAvaterUrl,@"nickname":self.targetNickName,@"age":@(self.targetAge),@"msgtype":@(ONSMessageType_Voice),@"replytype":@(ONSReplyType_Normal),@"medirlist":med};
    
    [KKSharedONSChatManager sendMessage:dic];
}

#pragma mark - EmoticonViewDelegate
-(void)emoticonViewTap:(NSString *)pngName text:(NSString *)text
{
    _onsInputView.textView.text=KKStringWithFormat(@"%@%@",_onsInputView.textView.text,text);
    KKLog(@"textviewtext:%@",_onsInputView.textView.text);
    
    [_onsInputView calTextViewHeight];
    
    //_onsInputView.textView.attributedText=[self showFace:_onsInputView.textView.text];
}

#pragma mark - MessageCellDelegate
-(void)messageCellTapHead:(ONSMessage *)message
{
    if(message.messageType!=ONSMessageType_System && message.messageDirection!=ONSMessageDirection_SEND)
    {
        RecommendUserInfoViewController *recommendUser = KKViewControllerOfMainSB(@"RecommendUserInfoViewController");
        recommendUser.uid =message.targetId;
        [self.navigationController pushViewController:recommendUser animated:YES];
    }
}

-(void)messageGotoVip
{
    VIPPayViewController *vipVC=KKViewControllerOfMainSB(@"VIPPayViewController");
    [self.navigationController pushViewController:vipVC animated:YES];
}

#pragma mark - ViewController lifecycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    KKLog(@"view vill appear");

    _quiting = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[self stopPlayingVoiceOrCancelRecord];
    KKLog(@"view will disappear");
    
    //更新未读数量
    [ONSSharedConversationDao updateNoUnReadCountByTargetId:self.targetId completion:^(BOOL success) {
        
        //读取新会话
        [KKNotificationCenter postNotificationName:ONSChatManagerNotification_UpdateConversation object:nil];
        
    } inBackground:YES];
    
    _quiting = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)dealloc {
    KKNotificationCenterRemoveObserverOfSelf;
    
    
    KKLog(@"%s", __func__);
}

#pragma mark -TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _messages.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_messages.count>indexPath.row)
    {
        ONSMessage *message=_messages[indexPath.row];
        return  message.cellHeight;
    }
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_messages.count>indexPath.row)
    {
        return [MessageCell cellWithTableView:tableView message:_messages[indexPath.row] avaterUrl:_targetIdAvaterUrl delegate:self];
    }
    return nil;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
}



@end
