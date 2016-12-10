//
//  CommentPopView.m
//  ONSChat
//
//  Created by 王磊 on 2016/12/1.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "CommentPopView.h"

@interface CommentPopView()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;

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
    self.commentTextView.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close:)];
    [self addGestureRecognizer:tap];
    
}

-(void)close:(UITapGestureRecognizer*)tap{
    [self.commentTextView resignFirstResponder];
    [self removeFromSuperview];
}


- (IBAction)sendCommentBtnClick:(id)sender {
    KKLog(@"发表 %@",self.commentTextView.text);
    [self.commentTextView resignFirstResponder];
    [self removeFromSuperview];
    if (self.sendComment) {
        self.sendComment(self.commentTextView.text);
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    _placeLabel.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if([textView.text isEqualToString:@""]){
        _placeLabel.hidden = NO;
    }else {
        _placeLabel.hidden = YES;
    }
}

-(void)dealloc{
    KKNotificationCenterRemoveObserverOfSelf
}
@end
