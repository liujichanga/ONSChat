//
//  ONSEmoticonView.h
//  ONSChat
//
//  Created by liujichang on 2016/12/5.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmoticonView : UIView

-(instancetype)initWithFrame:(CGRect)frame dic:(NSDictionary*)dic;

@property(strong,nonatomic) NSString *pngName;
@property(strong,nonatomic) NSString *text;

@end


@protocol ONSEmoticonViewDelegate <NSObject>

/**点击*/
-(void)emoticonViewTap:(NSString*)pngName text:(NSString*)text;

@end


@interface ONSEmoticonView : UIView

@property (weak, nonatomic) id<ONSEmoticonViewDelegate> delegate;


@end
