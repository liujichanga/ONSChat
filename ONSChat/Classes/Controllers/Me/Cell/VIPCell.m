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
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;


@end

@implementation VIPCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _tipLabel.textColor=KKColorPurple;
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
        
        _tipLabel.text=@"开通";
        if(KKSharedCurrentUser.isBaoYue)
        {
            _tipLabel.text=KKStringWithFormat(@"%@到期",KKSharedCurrentUser.baoyueEndTime);
        }
    }
    else if(index==1)
    {
        _iconImageView.image=[UIImage imageNamed:@"vip_img_1"];
        _vipTextLabel.text=@"VIP会员";
        
        _tipLabel.text=@"升级";
        if(KKSharedCurrentUser.isVIP)
        {
            _tipLabel.text=KKStringWithFormat(@"%@到期",KKSharedCurrentUser.vipEndTime);
        }
    }
    else
    {
        _iconImageView.image=[UIImage imageNamed:@"beans_img_1"];
        _vipTextLabel.text=@"红豆服务";
        
        _tipLabel.text=@"领取";
        if(KKSharedCurrentUser.beannum>0)
        {
            _tipLabel.text=KKStringWithFormat(@"%ld颗",KKSharedCurrentUser.beannum);
        }
    }
}

@end
