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

//开通短信包月
-(void)answerGotoBaoYue;

@end


@interface AnswerView : UIView

-(instancetype)initWithAnswer:(NSDictionary*)dic;

@property(strong,nonatomic) NSString *targetId;

@property (weak, nonatomic) id<AnswerViewDelegate> delegate;

@end
