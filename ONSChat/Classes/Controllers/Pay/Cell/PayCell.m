//
//  PayCell.m
//  ONSChat
//
//  Created by liujichang on 2016/12/9.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "PayCell.h"

@interface PayCell()

@property (weak, nonatomic) IBOutlet UIImageView *payImageView;
@property (weak, nonatomic) IBOutlet UILabel *payTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *payDescLabel;


@end

@implementation PayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)showDisplay:(NSInteger)index
{
    if(index==0)
    {
        _payImageView.image=[UIImage imageNamed:@"ic_pay_zf"];
        _payTitleLabel.text=@"支付宝";
        _payDescLabel.text=@"安全快捷，可支持银行卡支付";
    }
    else if(index==1)
    {
        _payImageView.image=[UIImage imageNamed:@"ic_pay_wx"];
        _payTitleLabel.text=@"微信支付";
        _payDescLabel.text=@"推荐在微信中绑定银行卡的用户使用";
    }
    else if(index==2)
    {
        _payImageView.image=[UIImage imageNamed:@"ic_pay_yy"];
        _payTitleLabel.text=@"语音银联";
        _payDescLabel.text=@"无需开通网银，电话支付，简单便捷";
    }
    else if(index==3)
    {
        _payImageView.image=[UIImage imageNamed:@"ic_pay_yl"];
        _payTitleLabel.text=@"银行卡支付";
        _payDescLabel.text=@"无需开通网银，支付全国167家银行";
    }
    else if(index==4)
    {
        _payImageView.image=[UIImage imageNamed:@"ic_pay_xyk"];
        _payTitleLabel.text=@"信用卡支付";
        _payDescLabel.text=@"无需开通网银，支持全国60家信用卡机构";
    }
}

@end
