//
//  CarouselCell.m
//  ONSChat
//
//  Created by mac on 2016/11/27.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "CarouselCell.h"
@interface CarouselCell()

@property (nonatomic, strong) KKCarouselView *carouselView;
@property (nonatomic, strong) UILabel *ageLab;
@end

@implementation CarouselCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
     KKCarouselView *carouseView = [[KKCarouselView alloc] initWithFrame:CGRectMake(0, 0, KKScreenWidth, KKScreenWidth)];
    [self.contentView addSubview:carouseView];
    self.carouselView = carouseView;
    
    UILabel *ageLab = [[UILabel alloc]initWithFrame:CGRectMake(10, carouseView.frame.size.height+10, 10, 30)];
    ageLab.backgroundColor = [UIColor cyanColor];
    ageLab.textColor = [UIColor whiteColor];
    [self.contentView addSubview:ageLab];
    self.ageLab = ageLab;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setAvatarArray:(NSArray *)avatarArray{
    _avatarArray = avatarArray;
    
    [self.carouselView setNetworkImageURLStr:avatarArray];
}

-(void)setAgeStr:(NSString *)ageStr{
    _ageStr =ageStr;
    self.ageLab.text = [NSString stringWithFormat:@" %@岁 ",ageStr];
    [self.ageLab sizeToFit];
}

@end
