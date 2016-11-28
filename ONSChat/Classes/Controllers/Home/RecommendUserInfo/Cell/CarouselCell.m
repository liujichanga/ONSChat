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
    
    UILabel *ageLab = [[UILabel alloc]initWithFrame:CGRectMake(10, carouseView.frame.size.height+13, 36, 24)];
    ageLab.backgroundColor = [UIColor cyanColor];
    ageLab.textColor = [UIColor whiteColor];
    ageLab.font = [UIFont systemFontOfSize:13];
    ageLab.textAlignment = NSTextAlignmentCenter;
    ageLab.layer.cornerRadius = 2.0;
    ageLab.layer.masksToBounds = YES;
    [self.contentView addSubview:ageLab];
    self.ageLab = ageLab;
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(ageLab.frame.origin.x+ageLab.frame.size.width+5, ageLab.frame.origin.y, 73, 24)];
    lab.text = @"身份已验证";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.backgroundColor = [UIColor orangeColor];
    lab.textColor = [UIColor whiteColor];
    lab.font = [UIFont systemFontOfSize:13];
    lab.layer.cornerRadius = 2.0;
    lab.layer.masksToBounds = YES;
    [self.contentView addSubview:lab];
    
    UIImageView* vipImg = [[UIImageView alloc]initWithFrame:CGRectMake(lab.frame.origin.x+lab.frame.size.width+5, carouseView.frame.size.height+10, 53, 21)];
    vipImg.image = [UIImage imageNamed:@"near_vip_one"];
    vipImg.center = CGPointMake(vipImg.center.x, lab.center.y);
    [self.contentView addSubview:vipImg];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setAvatarArray:(NSArray *)avatarArray{
    _avatarArray = avatarArray;
    
    [self.carouselView setNetworkImageURLStr:avatarArray];
}

-(void)setAge:(NSInteger)age{
    _age =age;
    self.ageLab.text = [NSString stringWithFormat:@"%ld岁",(long)age];
}

@end
