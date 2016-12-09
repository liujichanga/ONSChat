//
//  MyInfoPickerView.h
//  ONSChat
//
//  Created by 王磊 on 2016/12/9.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyInfoPickerView : UIView
+(instancetype)createMyInfoPickerViewFrame:(CGRect)frame inView:(UIView*)view;

-(void)showInfoPickerViewWithType:(MyInfoType)type;

@property (nonatomic, strong) NSDictionary *dataDic;
@end
