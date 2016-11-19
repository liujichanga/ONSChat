//
//  KKBaseUINavigationController.m
//  FSLeftBarItemDemo
//
//  Created by liujichang on 16/3/24.
//  Copyright © 2016年 liujichang. All rights reserved.
//

#import "KKBaseNavigationController.h"


@interface KKBaseNavigationController ()

@end

@implementation KKBaseNavigationController


- (void)viewDidLoad {
    [super viewDidLoad];
    //self.interactivePopGestureRecognizer.delegate = self;
    NSLog(@"KKBaseNavigationController view did");
}

//自定义返回按钮的同时支持右滑事件,需要在gestureRecognizerShouldBegin把不支持右划的都写上,暂时不用这种方式
/*
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    BOOL ok = YES; // 默认为支持右滑返回
    if(self.viewControllers.count<=1) ok=NO;//根controller不支持右滑，否则会卡死
    //需要在这里把不支持右划的controller都写上
    if ([self.topViewController isKindOfClass:[HYBBaseViewController class]]) {
        if ([self.topViewController respondsToSelector:@selector(gestureRecognizerShouldBegin)]) {
            HYBBaseViewController *vc = (HYBBaseViewController *)self.topViewController;
            ok = [vc gestureRecognizerShouldBegin];
        }
    }
    
    NSLog(@"viewcontrolles:%@",self.viewControllers);
    NSLog(@"gesture ok%d",ok);
   
    return ok;
}
 */


@end
