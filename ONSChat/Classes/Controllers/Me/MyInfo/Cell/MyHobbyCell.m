//
//  MyHobbyCell.m
//  ONSChat
//
//  Created by 王磊 on 2016/12/7.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "MyHobbyCell.h"
#import "OptionsView.h"

@interface MyHobbyCell()
@property (nonatomic, strong) OptionsView *opView;
@end

@implementation MyHobbyCell

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
    //取余算行数 根据行数计算高度
    int v = dataArr.count%3;
    if (v!=0) {
        viewH = 30*((dataArr.count/3)+1);
    }else{
        viewH = 30*(dataArr.count/3);
    }
    //创建选项View
    if (!self.opView) {
        OptionsView *opView = [[OptionsView alloc]initWithFrame:CGRectMake(0, 40, KKScreenWidth, viewH) andData:dataArr andSelectedHobby:self.selectedHobbyStr];
        self.opView = opView;
        [self.contentView addSubview:opView];
    }

    if (self.cellHeight) {
        self.cellHeight(viewH+45);
    }
}
//保存选项答案
-(void)saveInfo{
    KKLog(@"兴趣");
    NSString *hobbyStr;
    for (UIButton*btn in self.opView.optionBtnArr) {
        if (btn.selected==YES) {
            KKLog(@"%@",btn.titleLabel.text);
            if (hobbyStr.length==0) {
                hobbyStr =btn.titleLabel.text;
            }else{
                hobbyStr = [hobbyStr stringByAppendingString:[NSString stringWithFormat:@",%@",btn.titleLabel.text]];
            }
        }
    }
    KKSharedCurrentUser.hobby = hobbyStr;
}

-(void)dealloc{
    KKNotificationCenterRemoveObserverOfSelf
}
@end
