//
//  BaoYueHeadCell.m
//  ONSChat
//
//  Created by liujichang on 2016/12/10.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "BaoYueHeadCell.h"

@interface BaoYueHeadCell()

@property (weak, nonatomic) IBOutlet UILabel *titleDateLabel;

@property (weak, nonatomic) IBOutlet UIButton *baoyueButton;
@property (weak, nonatomic) IBOutlet UIButton *beanButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baoyueLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *benRightConstraint;

@property (weak, nonatomic) IBOutlet UIView *leftLineView;
@property (weak, nonatomic) IBOutlet UIView *rightLineView;


@end

@implementation BaoYueHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle=UITableViewCellSelectionStyleNone;

    _titleDateLabel.text=KKStringWithFormat(@"截止%@",[[[NSDate date] dateByAddingDays:2] stringWithFormat:@"yyyy年MM月dd日"]);
    _titleDateLabel.textColor=KKColorPurple;
    
    _baoyueLeftConstraint.constant=KKScreenWidth*0.25-30;
    _benRightConstraint.constant=KKScreenWidth*0.25-30;
    
    [_baoyueButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_baoyueButton setTitleColor:KKColorPurple forState:UIControlStateSelected];
    
    [_beanButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_beanButton setTitleColor:KKColorPurple forState:UIControlStateSelected];
    
    _leftLineView.hidden=YES;
    _rightLineView.hidden=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)baoyueClick:(UIButton*)sender {
    _baoyueButton.selected=YES;
    _leftLineView.hidden=NO;
    
    _beanButton.selected=NO;
    _rightLineView.hidden=YES;
    
    if(self.baoyueClickBlock) self.baoyueClickBlock();
}
- (IBAction)beanClick:(UIButton*)sender {
    
    _beanButton.selected=YES;
    _rightLineView.hidden=NO;
    
    _baoyueButton.selected=NO;
    _leftLineView.hidden=YES;
    
    if(self.beanClickBlock) self.beanClickBlock();
}

-(void)showDisplay:(NSInteger)type
{
    if(type==1)
    {
        //包月
        _baoyueButton.selected=YES;
        _leftLineView.hidden=NO;
        
        _beanButton.selected=NO;
        _rightLineView.hidden=YES;
    }
    else
    {
        //红豆
        _beanButton.selected=YES;
        _rightLineView.hidden=NO;
        
        _baoyueButton.selected=NO;
        _leftLineView.hidden=YES;
    }
}

@end
