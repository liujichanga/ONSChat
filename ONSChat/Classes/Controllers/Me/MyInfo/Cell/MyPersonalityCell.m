//
//  MyPersonalityCell.m
//  ONSChat
//
//  Created by 王磊 on 2016/12/7.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "MyPersonalityCell.h"
#import "OptionsView.h"
@interface MyPersonalityCell()
@property (nonatomic, strong) OptionsView *opView;

@end

@implementation MyPersonalityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    KKNotificationCenterAddObserverOfSelf(saveInfo, @"saveInfo", nil);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    CGFloat viewH = 0.0;
    //取余算行数
    int v = dataArr.count%3;
    if (v!=0) {
        viewH = 30*((dataArr.count/3)+1);
    }else{
        viewH = 30*(dataArr.count/3);
    }
    if (!self.opView) {
        OptionsView *opView = [[OptionsView alloc]initWithFrame:CGRectMake(0, 40, KKScreenWidth, viewH) andData:dataArr andSelectedHobby:_selectedInfoStr];
        [self.contentView addSubview:opView];
        self.opView = opView;
    }
    if (self.cellHeight) {
        self.cellHeight(viewH+45);
    }
}

-(void)saveInfo{
    KKLog(@"个性");
    NSString *personalityStr;
    for (UIButton* btn in self.opView.optionBtnArr) {
        if (btn.selected==YES) {
            if (personalityStr.length==0) {
                personalityStr =btn.titleLabel.text;
            }else{
                personalityStr = [personalityStr stringByAppendingString:[NSString stringWithFormat:@",%@",btn.titleLabel.text]];
            }
        }
    }
    KKSharedCurrentUser.personality = personalityStr;
}

-(void)dealloc{

    KKNotificationCenterRemoveObserverOfSelf
}
@end
