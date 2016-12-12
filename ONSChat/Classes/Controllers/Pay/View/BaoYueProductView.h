//
//  BaoYueProductView.h
//  ONSChat
//
//  Created by liujichang on 2016/12/10.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaoYueProductView : UIView

+ (instancetype)productView;


@property (nonatomic, copy) void(^buyProductBlock)(NSDictionary *dic);


@property (weak, nonatomic) IBOutlet UIImageView *saleImageView;

@property(strong,nonatomic) NSDictionary *productDic;

@end
