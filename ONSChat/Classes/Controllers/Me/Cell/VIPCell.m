//
//  VIPCell.m
//  ONSChat
//
//  Created by liujichang on 2016/11/22.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "VIPCell.h"

@interface VIPCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *vipTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *saleImageView;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;


@end

@implementation VIPCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)showText:(NSInteger)index
{
    _saleImageView.hidden=YES;
    
    if(index==0)
    {
        _iconImageView.image=[UIImage imageNamed:@"msg_img_1"];
        _vipTextLabel.text=@"包月写信";
        _saleImageView.hidden=NO;
        
        [_actionButton setTitle:@"开通" forState:UIControlStateNormal];
    }
    else if(index==1)
    {
        _iconImageView.image=[UIImage imageNamed:@"vip_img_1"];
        _vipTextLabel.text=@"VIP会员";
        
        [_actionButton setTitle:@"升级" forState:UIControlStateNormal];
    }
    else
    {
        _iconImageView.image=[UIImage imageNamed:@"beans_img_1"];
        _vipTextLabel.text=@"红豆服务";
        
        [_actionButton setTitle:@"领取" forState:UIControlStateNormal];
    }
}

@end
