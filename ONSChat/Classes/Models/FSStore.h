//
//  FSStore.h
//  ONSChat
//
//  Created by liujichang on 2016/12/9.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FSStoreDelegate <NSObject>

/** 购买成功 */
-(void)buySucceed:(NSString*)productId;

@end


@interface FSStore : NSObject

//是否允许购买
-(BOOL)canPayment;

//购买产品
-(void)buyProduct:(NSString*)productId;

@property (weak, nonatomic) id<FSStoreDelegate> delegate;

@end
