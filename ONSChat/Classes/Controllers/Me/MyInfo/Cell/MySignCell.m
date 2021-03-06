//
//  MySignCell.m
//  ONSChat
//
//  Created by 王磊 on 2016/12/7.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "MySignCell.h"

@interface MySignCell()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *signText;

@property (weak, nonatomic) IBOutlet UILabel *placeLabel;


@end

@implementation MySignCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _signText.delegate = self;
    _signText.layer.borderWidth = 0.5;
    _signText.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    
    KKNotificationCenterAddObserverOfSelf(saveInfo, @"saveInfo", nil);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setUserSign:(NSString *)userSign{
    _userSign = userSign;
    _signText.text = userSign;
}

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


-(void)saveInfo{
    KKLog(@"内心独白");
    KKSharedCurrentUser.sign = self.signText.text;
}

-(void)dealloc{
    KKNotificationCenterRemoveObserverOfSelf
}
@end
