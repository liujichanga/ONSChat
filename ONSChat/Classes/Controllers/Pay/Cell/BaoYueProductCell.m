//
//  BaoYueProductCell.m
//  ONSChat
//
//  Created by liujichang on 2016/12/10.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "BaoYueProductCell.h"
#import "BaoYueProductView.h"

@implementation BaoYueProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle=UITableViewCellSelectionStyleNone;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)showDisplay:(NSArray *)arr
{
    NSArray *arrview=self.contentView.subviews;
    for (UIView *view in arrview) {
        if(view.tag>=200) [view removeFromSuperview];
    }

    CGFloat orignY=5;
    KKWEAKSELF;
    for (int i=0; i<arr.count; i++) {
        NSDictionary *dic=arr[i];
        BaoYueProductView *view=[BaoYueProductView productView];
        view.frame=CGRectMake(0, orignY, KKScreenWidth, 75);
        view.productDic=dic;
        view.tag=200+i;
        if(i==0)
        {
            view.saleImageView.image=[UIImage imageNamed:@"buy_1"];
        }
        else if(i==1)
        {
            view.saleImageView.image=[UIImage imageNamed:@"buy_2"];
        }
        [self.contentView addSubview:view];
        orignY+=75+10;
        
        view.buyProductBlock=^(NSDictionary *dic){
          
            if(weakself.buyProductClickBlock) weakself.buyProductClickBlock(dic);
            
        };
    }
}

@end
