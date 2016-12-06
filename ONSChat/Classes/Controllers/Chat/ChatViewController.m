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



@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource,ONSInputViewDelegate,WZMRecordViewDelegate,ONSEmoticonViewDelegate,MessageCellDelegate>

@property (weak, nonatomic) UITableView *tableView;

@property(strong,nonatomic) ONSInputView *onsInputView;

/** 录音组件 */
@property (weak, nonatomic) WZMRecordView *recordView;
/** 表情面板 */
@property (weak, nonatomic) ONSEmoticonView *emotionView;

/** 是否正在退出当前界面 */
@property (assign, nonatomic) BOOL quiting;

//聊天的数组
@property(strong,nonatomic) NSMutableArray *messages;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor=KKColorFromRGB(0xF2F2F2);
    
    _messages=[NSMutableArray array];
    
    //UITableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.backgroundColor = KKColorFromRGB(0xF2F2F2);
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    KKWEAKSELF;
    [ONSSharedMessageDao getMessageListByTargetId:self.targetId Completion:^(id result) {
        
        if(result)
        {
            NSArray *arr=(NSArray*)result;
            for (ONSMessage *message in arr) {
                [message calLayout];
            }
            [weakself.messages addObjectsFromArray:arr];
            [weakself.tableView reloadData];
        }
        
    } inBackground:YES];
    
    // 输入组件
    ONSInputView *toolView = [[ONSInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-90, KKScreenWidth, 90)];
    toolView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    toolView.delegate = self;
    _onsInputView = toolView;
    [self.view addSubview:_onsInputView];
    [self setTableViewBottomInset:0.0];
    
    // 单击TableView隐藏键盘
    [self.tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)]];
    [self.tableView.panGestureRecognizer addTarget:self action:@selector(dismissKeyboard)];
    // 监听键盘
    KKNotificationCenterAddObserverOfSelf(dealKeyboard:, UIKeyboardWillChangeFrameNotification, nil)
    
}

#pragma mark - Private
/** 设置TableView的底部内边距 */
- (void)setTableViewBottomInset:(CGFloat)bottomInset {
    UIEdgeInsets inset = self.tableView.contentInset;
    //    if ([UINavigationBar appearance].isTranslucent) {
    inset.top = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    //    }
    inset.bottom = _onsInputView.frame.size.height + bottomInset;
    self.tableView.contentInset = inset;
    self.tableView.scrollIndicatorInsets = inset;
}

#pragma mark - WZMInputView delegate
/** 文本内容输入完成 */
- (void)inputView:(ONSInputView *)inputView didEndEditingText:(NSString *)text {
    //[SharedMessageCenter sendTextMesage:text receiverId:_buddy.userIdStirng];
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
}

#pragma mark - EmoticonViewDelegate
-(void)emoticonViewTap:(NSString *)pngName text:(NSString *)text
{
    _onsInputView.textView.text=KKStringWithFormat(@"%@%@",_onsInputView.textView.text,text);
    KKLog(@"textviewtext:%@",_onsInputView.textView.text);
    
    [_onsInputView calTextViewHeight];
    
    //_onsInputView.textView.attributedText=[self showFace:_onsInputView.textView.text];
}

#pragma mark - ViewController lifecycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 在返回按钮上显示未读消息数
//    [WZMThredUtils runInMainQueue:^{
//        [self displayUnreadCount];
//    } delay:0.5];
    _quiting = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[self stopPlayingVoiceOrCancelRecord];
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
    
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(_messages.count>indexPath.row)
    {
        return [MessageCell cellWithTableView:tableView message:_messages[indexPath.row] delegate:self];
    }
    return nil;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
   
    
}



//显示表情,用属性字符串显示表情
-(NSMutableAttributedString *)showFace:(NSString *)str
{
    if (str != nil) {
        //获取plist中的数据
        NSArray *face =KKSharedGlobalManager.emoticons;
        
        //创建一个可变的属性字符串
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:str];
        
        UIFont *baseFont = [UIFont systemFontOfSize:17];
        [attributeString addAttribute:NSFontAttributeName value:baseFont range:NSMakeRange(0, str.length)];
        
        //正则匹配要替换的文字的范围
        //正则表达式
        NSString * pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        NSError *error = nil;
        NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        
        if (!re) {
            NSLog(@"err %@", [error localizedDescription]);
        }
        
        //通过正则表达式来匹配字符串
        NSArray *resultArray = [re matchesInString:str options:0 range:NSMakeRange(0, str.length)];
        
        //用来存放字典，字典中存储的是图片和图片对应的位置
        NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
        
        //根据匹配范围来用图片进行相应的替换
        for(NSTextCheckingResult *match in resultArray) {
            //获取数组元素中得到range
            NSRange range = [match range];
            
            //获取原字符串中对应的值
            NSString *subStr = [str substringWithRange:range];
            
            for (int i = 0; i < face.count; i ++)
            {
                if ([face[i][@"chs"] isEqualToString:subStr])
                {
                    //新建文字附件来存放我们的图片
                    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                    
                    //给附件添加图片
                    textAttachment.image = [UIImage imageNamed:face[i][@"png"]];
                    
                    //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
                    NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                    
                    //把图片和图片对应的位置存入字典中
                    NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
                    [imageDic setObject:imageStr forKey:@"image"];
                    [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                    
                    //把字典存入数组中
                    [imageArray addObject:imageDic];
                    
                }
            }
        }
        
        if (imageArray.count > 0) {
            //从后往前替换
            for (int i = (int)imageArray.count -1; i >= 0; i--)
            {
                NSRange range;
                [imageArray[i][@"range"] getValue:&range];
                //进行替换
                [attributeString replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
                
            }
            
        }
        NSLog(@"face attr:%@",attributeString);
        return  attributeString;
        
    }
    
    return nil;
    
}


@end
