//
//  PartnerAddressCell.m
//  ONSChat
//
//  Created by 王磊 on 2016/12/13.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "PartnerAddressCell.h"
//间隔
#define Interval 1
//高度
#define BtnH KKScreenWidth*(50/320.0)

@interface PartnerAddressCell()
@property (weak, nonatomic) IBOutlet UILabel *selectedInfoLab;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSMutableArray *btnsArr;

@end

@implementation PartnerAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.btnsArr = [NSMutableArray array];
    
    NSString *str = [KKSharedLocalPlistManager kkStringForKey:Plist_Key_PartnerAddress];
    if (str.length>0) {
        self.selectedInfoLab.text = str;
    }
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, 10, 10)];
    bgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:bgView];
    self.bgView = bgView;
    
    //第一个选项的Y值
    CGFloat startY = 1;
    CGFloat btnW = (KKScreenWidth-Interval)/4.0;
    CGFloat btnY = 0.0;
    for (int i = 0; i<KKSharedGlobalManager.addressArr.count; i++) {
        NSString *optionStr = [KKSharedGlobalManager.addressArr objectAtIndex:i];
        
        int v = i/4;//行
        int h = i%4;//列
        CGFloat btnX = (btnW+Interval)*h;
        btnY = startY+((BtnH+Interval)*v);
        
        CGRect btnFrame = CGRectMake(btnX, btnY, btnW, BtnH);
        UIButton *btn = [[UIButton alloc]initWithFrame:btnFrame];
        [btn setTitle:optionStr forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:KKColorPurple forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:btn];
        [self.btnsArr addObject:btn];
        //已有答案 默认选中已选答案 没有答案 默认选中第一项
        if (str.length>0) {
            if ([str isEqualToString:optionStr]) {
                btn.selected = YES;
            }
        }else{
            if (i==0) {
                btn.selected = YES;
            }
        }
    }
    self.bgView.frame = CGRectMake(0, 45, KKScreenWidth, btnY+BtnH);
    
    KKNotificationCenterAddObserverOfSelf(savePartnerConditions, @"savePartnerConditions", nil);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)btnClick:(UIButton*)btn{
    for (UIButton *btn in self.btnsArr) {
        btn.selected = NO;
    }
    btn.selected = YES;
    self.selectedInfoLab.text = btn.titleLabel.text;
}

-(void)savePartnerConditions{
    
    KKLog(@"居住 %@",self.selectedInfoLab.text);
    [KKSharedLocalPlistManager setKKValue:self.selectedInfoLab.text forKey:Plist_Key_PartnerAddress];

}

-(void)dealloc{
    KKNotificationCenterRemoveObserverOfSelf
}
@end
