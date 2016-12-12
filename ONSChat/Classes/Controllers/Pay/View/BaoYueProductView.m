//
//  BaoYueProductView.m
//  ONSChat
//
//  Created by liujichang on 2016/12/10.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "BaoYueProductView.h"

@interface BaoYueProductView()

@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productInfoLabel;
@property (weak, nonatomic) IBOutlet ONSButtonPurple *buyButton;
@property (weak, nonatomic) IBOutlet UILabel *productSaleInfoLabel;


@end

@implementation BaoYueProductView

+ (instancetype)productView {
    return KKViewOfMainBundle(@"BaoYueProductView");
}

-(void)setProductDic:(NSDictionary *)productDic
{
    _productDic=productDic;
    
    _productNameLabel.text=[productDic stringForKey:@"name" defaultValue:@""];
    _productInfoLabel.text=[productDic stringForKey:@"info" defaultValue:@""];
    [_buyButton setTitle:KKStringWithFormat(@"%ld元",[productDic integerForKey:@"price" defaultValue:0]/100) forState:UIControlStateNormal];
    _productSaleInfoLabel.text=[productDic stringForKey:@"unit" defaultValue:@""];
}

- (IBAction)buyClick:(id)sender {
    
    if(self.buyProductBlock) self.buyProductBlock(_productDic);
}
@end
