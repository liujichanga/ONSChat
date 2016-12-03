//
//  CommentPopView.m
//  ONSChat
//
//  Created by 王磊 on 2016/12/1.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "CommentPopView.h"

@interface CommentPopView()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;

@end

@implementation CommentPopView


+(instancetype)showCommentPopViewInView:(UIView*)view AndFrame:(CGRect)frame{
    CommentPopView *popView = KKViewOfMainBundle(@"CommentPopView");
    popView.frame = frame;
    [view addSubview:popView];
    
    return popView;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 3.0;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.borderWidth = 1.0;
    self.bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.commentTextField.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close:)];
    [self addGestureRecognizer:tap];
    
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)close:(UITapGestureRecognizer*)tap{
    [self.commentTextField resignFirstResponder];
    [self removeFromSuperview];
}

//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    NSLog(@"hight_hitht:%f",kbSize.height);
    
    [UIView animateWithDuration:0.4f animations:^{
        
        self.frame = CGRectMake(0.0f, -kbSize.height, self.frame.size.width, self.frame.size.height);
    }];
}

//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [UIView animateWithDuration:0.4f animations:^{
        self.frame =CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }];
}

- (IBAction)sendCommentBtnClick:(id)sender {
    KKLog(@"发表 %@",self.commentTextField.text);
    [self.commentTextField resignFirstResponder];
    [self removeFromSuperview];
    if (self.sendComment) {
        self.sendComment(self.commentTextField.text);
    }
}

#pragma mark - UITextFieldDelegate
//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)dealloc{
    KKNotificationCenterRemoveObserverOfSelf
}
@end
