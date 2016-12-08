//
//  AnswerView.h
//  ONSChat
//
//  Created by liujichang on 2016/12/7.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AnswerViewDelegate <NSObject>

/**点击*/
-(void)answerViewTap:(NSString*)answer;

@end


@interface AnswerView : UIView

-(instancetype)initWithAnswer:(NSDictionary*)dic;

@property (weak, nonatomic) id<AnswerViewDelegate> delegate;

@end
