//
//  OptionsView.h
//  ONSChat
//
//  Created by 王磊 on 2016/12/7.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionsView : UIView
-(instancetype)initWithFrame:(CGRect)frame andData:(NSArray*)optionArray andSelectedHobby:(NSString*)selectedInfo;
//选项数组
@property (nonatomic, strong) NSMutableArray *optionBtnArr;
@end
