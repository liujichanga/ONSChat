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
}

#pragma mark - UITextFieldDelegate
//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    self.frame = CGRectMake(0.0f, -246, self.frame.size.width, self.frame.size.height);
    
    [UIView commitAnimations];
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.frame =CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}


-(void)close:(UITapGestureRecognizer*)tap{
    [self.commentTextField resignFirstResponder];
    [self removeFromSuperview];
}

- (IBAction)sendCommentBtnClick:(id)sender {
    
    KKLog(@"发表 %@",self.commentTextField.text);
    [self.commentTextField resignFirstResponder];
    [self removeFromSuperview];
}

@end
