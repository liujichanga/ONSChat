//
//  TopPageView.m
//  ONSChat
//
//  Created by 王磊 on 2016/11/23.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "TopPageView.h"
@interface TopPageView()
//页数数组
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *pageArray;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *lineArray;
@property (nonatomic, assign) NSInteger pageNub;
@end


@implementation TopPageView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self pageViewUI];
}

-(void)pageViewUI{
    
    for (UIButton* btn in self.pageArray) {
        CGFloat radius = 15.0;
        
        [btn.layer setMasksToBounds:YES];
        [btn.layer setCornerRadius:radius];
        
        [btn setBackgroundImage:[UIImage imageWithColor:KKColorPurple forSize:self.frame.size radius:radius borderWidth:0 borderColor:nil] forState:UIControlStateSelected];
    }
}

+(instancetype)showPageViewWith:(NSInteger)pageNub{
    
    TopPageView *view = KKViewOfMainBundle(@"TopPageView");
    view.frame = CGRectMake(0, 70, KKScreenWidth, 60);
    view.pageNub = pageNub;
    return view;
}

-(void)setPageNub:(NSInteger)pageNub{
    _pageNub = pageNub;
    
    for (int i = 0; i < (pageNub-1)*2; ++i) {
        UIView *line = [self.lineArray objectAtIndex:i];
        line.backgroundColor = KKColorPurple;
    }
    
    for (UIButton *btn in self.pageArray) {
        //tag小于等于 选中
        if (btn.tag <= pageNub) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
            break;
        }
    }
}
@end
