//
//  TwoPicCell.m
//  ONSChat
//
//  Created by liujichang on 2016/11/23.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "TwoPicCell.h"

@interface TwoPicCell()

@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftAgeLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftLikeButton;

@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *rightNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightAgeLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightLikeButton;


@property(strong,nonatomic) KKUser *leftUser;
@property(strong,nonatomic) KKUser *rightUser;

@end

@implementation TwoPicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    [_leftView.layer setMasksToBounds:YES];
    [_leftView.layer setCornerRadius:5.0];
    [_rightView.layer setMasksToBounds:YES];
    [_rightView.layer setCornerRadius:5.0];
    
    UITapGestureRecognizer *leftheadGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftTap:)];
    [self.leftView addGestureRecognizer:leftheadGestureRecognizer];
    
    UITapGestureRecognizer *rightheadGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightTap:)];
    [self.rightView addGestureRecognizer:rightheadGestureRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)leftTap:(id)sender
{
    if(self.clickBlock) self.clickBlock(self.leftUser);
}

-(void)rightTap:(id)sender
{
    if(self.clickBlock) self.clickBlock(self.rightUser);
}

- (IBAction)leftLikeClick:(id)sender {
    
    if(!_leftLikeButton.selected)
    {
        //提交接口
        NSDictionary *params=@{@"fid":self.leftUser.userId};
        [FSSharedNetWorkingManager POST:ServiceInterfaceLike parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
        _leftUser.isliked=YES;
        _leftLikeButton.selected=YES;
    }
    else
    {
        [MBProgressHUD showMessag:@"已经喜欢过了" toView:nil];
    }
}
- (IBAction)rightLickClick:(id)sender {
  
    if(!_rightLikeButton.selected)
    {
        //提交接口
        NSDictionary *params=@{@"fid":self.rightUser.userId};
        [FSSharedNetWorkingManager POST:ServiceInterfaceLike parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
        _rightUser.isliked=YES;
        _rightLikeButton.selected=YES;
    }
    else
    {
        [MBProgressHUD showMessag:@"已经喜欢过了" toView:nil];
    }
}

-(void)displayLeftDic:(KKUser*)leftUser rightDic:(KKUser*)rightUser
{
    _leftUser = leftUser;
    _rightUser = rightUser;
    
    _leftImageView.image=[UIImage imageNamed:@"def_head"];
    NSString *leftimageurl=leftUser.avatarUrl;
    if(KKStringIsNotBlank(leftimageurl))
    {
        KKImageViewWithUrlstring(_leftImageView, leftimageurl, @"def_head");
    }
    _leftNameLabel.text=leftUser.nickName;
    _leftAgeLabel.text=KKStringWithFormat(@"%ld岁 %@市",leftUser.age,KKSharedGlobalManager.GPSCity);
    _leftLikeButton.selected=leftUser.isliked;
    
    
    _rightImageView.image=[UIImage imageNamed:@"def_head"];
    NSString *rightimageurl=rightUser.avatarUrl;
    if(KKStringIsNotBlank(rightimageurl))
    {
        KKImageViewWithUrlstring(_rightImageView, rightimageurl, @"def_head");
    }
    _rightNameLabel.text=rightUser.nickName;
    _rightAgeLabel.text=KKStringWithFormat(@"%ld岁 %@市",rightUser.age,KKSharedGlobalManager.GPSCity);
    _rightLikeButton.selected=rightUser.isliked;

}



@end
