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

-(void)close:(UITapGestureRecognizer*)tap{
    [self.commentTextField resignFirstResponder];
    [self removeFromSuperview];
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
