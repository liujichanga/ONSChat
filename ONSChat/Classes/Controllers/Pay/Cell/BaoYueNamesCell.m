//
//  BaoYueNamesCell.m
//  ONSChat
//
//  Created by liujichang on 2016/12/10.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "BaoYueNamesCell.h"

@interface BaoYueNamesCell()

@property(strong,nonatomic) NSTimer *timer;

@end

@implementation BaoYueNamesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle=UITableViewCellSelectionStyleNone;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setNamesArr:(NSArray *)namesArr
{
    _namesArr=namesArr;
    
    NSArray *arrview=self.contentView.subviews;
    for (UIView *view in arrview) {
        if(view.tag>=100) [view removeFromSuperview];
    }
    
    CGFloat originY=45;
    
    for (int i=0; i<10; i++) {
        
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(20, originY, KKScreenWidth-50, 21)];
        label.textColor=[UIColor darkTextColor];
        label.font=[UIFont systemFontOfSize:14];
        label.tag=100+i;
        [self.contentView addSubview:label];
        
        originY+=21;
    }
    
    [self timerCheck];
    
    if([self.timer isValid])
    {
        [self.timer invalidate];
        self.timer=nil;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerCheck) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)timerCheck
{
    int value = arc4random() % (_namesArr.count-10);
    int tag=100;
    for (int i=value; i<_namesArr.count; i++) {
        UIView *view=[self.contentView viewWithTag:tag];
        if(view)
        {
            UILabel *label=(UILabel*)view;
            label.attributedText=nil;
            NSString *name=_namesArr[i];
            NSString *str=KKStringWithFormat(@"[%@]刚刚获得了100元话费",name);
            NSRange rang=NSMakeRange(0,name.length+2);
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
            [attributedString addAttribute:NSForegroundColorAttributeName value:KKColorPurple range:rang];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:rang];
            label.attributedText=attributedString;
            
            tag++;
        }
    }
}

-(void)dealloc
{
    if([self.timer isValid])
    {
        [self.timer invalidate];
        self.timer=nil;
    }
}

@end
