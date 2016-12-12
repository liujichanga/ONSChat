//
//  VIPProductCell.m
//  ONSChat
//
//  Created by liujichang on 2016/12/8.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "VIPProductCell.h"

@implementation VIPProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle=UITableViewCellSelectionStyleNone;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)showInfo:(NSArray *)arr
{
    NSArray *arrview=[self.contentView subviews];
    for (UIView *view in arrview) {
        if(view.tag>=100) [view removeFromSuperview];
    }
    
    CGFloat origY=60;
    for (int i=0; i<arr.count; i++) {
        NSDictionary *dic=arr[i];
        ONSButtonPurple *btn=[ONSButtonPurple ONSButtonWithTitle:[dic stringForKey:@"name" defaultValue:@""] frame:CGRectMake(40, origY, KKScreenWidth-80, 45)];
        btn.tag=100+i;
        [self.contentView addSubview:btn];
        origY+=45+15;
        
        [btn addTarget:self action:@selector(vipBuy:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

-(void)vipBuy:(UIButton*)sender{
    NSInteger index=sender.tag-100;
    if(self.buyProduct) self.buyProduct(index);
}

@end
