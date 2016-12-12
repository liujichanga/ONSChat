//
//  IdentifierCell.m
//  ONSChat
//
//  Created by liujichang on 2016/12/12.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "IdentifierCell.h"

@interface IdentifierCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleTextLabel;

@property (weak, nonatomic) IBOutlet UIImageView *star1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *star2ImageView;
@property (weak, nonatomic) IBOutlet ONSButton *actionButton;

//行的索引
@property(assign,nonatomic) NSInteger index;

@end

#define GoldColor [UIColor colorWithRed:254.0/255.0 green:211.0/255.0 blue:85.0/255.0 alpha:1.0]

@implementation IdentifierCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _star1ImageView.image=[[UIImage imageNamed:@"star"] imageWithColor:[UIColor lightGrayColor]];
    _star2ImageView.image=[[UIImage imageNamed:@"star"] imageWithColor:[UIColor lightGrayColor]];

    _star2ImageView.hidden=YES;
    
    self.selectionStyle=UITableViewCellSelectionStyleNone;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)showDisplayInfo:(NSInteger)index completedInfo:(NSInteger)completed
{
    self.index=index;
    
    _star2ImageView.hidden=YES;
    
    if(index==0)
    {
        _iconImageView.image=[UIImage imageNamed:@"vetify_id"];
        _titleTextLabel.text=@"身份认证";
        _subtitleTextLabel.text=@"";
        
        //星星判断
        _star2ImageView.hidden=NO;
        _star1ImageView.image=[[UIImage imageNamed:@"star"] imageWithColor:[UIColor lightGrayColor]];
        _star2ImageView.image=[[UIImage imageNamed:@"star"] imageWithColor:[UIColor lightGrayColor]];
        
        //按钮判断
        if(KKStringIsNotBlank([KKSharedLocalPlistManager kkStringForKey:Plist_Key_IdentifierName]))
        {
            [_actionButton setTitle:@"审核中" forState:UIControlStateNormal];
        }
        else
        {
            [_actionButton setTitle:@"去认证" forState:UIControlStateNormal];
        }        
    }
    else if(index==1)
    {
        _iconImageView.image=[UIImage imageNamed:@"vetify_phone"];
        _titleTextLabel.text=@"手机认证";
        _subtitleTextLabel.text=@"";
        
        //星星判断
        _star1ImageView.image=[[UIImage imageNamed:@"star"] imageWithColor:[UIColor lightGrayColor]];
        if(KKSharedCurrentUser.isPhone)
        {
            _star1ImageView.image=[[UIImage imageNamed:@"star"] imageWithColor:GoldColor];
        }
        //按钮判断
        if(KKSharedCurrentUser.isPhone)
        {
            [_actionButton setTitle:@"已认证" forState:UIControlStateNormal];
        }
        else
        {
            [_actionButton setTitle:@"去认证" forState:UIControlStateNormal];
        }
    }
    else if(index==2)
    {
        _iconImageView.image=[UIImage imageNamed:@"vetify_photo"];
        _titleTextLabel.text=@"上传本人3张照片";
        
        //获取照片数量
        NSInteger count = [KKSharedGlobalManager getPhotosCount];
        
        _subtitleTextLabel.text=KKStringWithFormat(@"目前有%ld照片",count);
        
        //星星判断
        _star1ImageView.image=[[UIImage imageNamed:@"star"] imageWithColor:[UIColor lightGrayColor]];
        if(count>=3)
        {
            _star1ImageView.image=[[UIImage imageNamed:@"star"] imageWithColor:GoldColor];
        }
        
        //按钮判断
        [_actionButton setTitle:@"添加照片" forState:UIControlStateNormal];
       
    }
    else if(index==3)
    {
        _iconImageView.image=[UIImage imageNamed:@"vetify_info"];
        _titleTextLabel.text=@"资料达到90%";
      
        _subtitleTextLabel.text=KKStringWithFormat(@"目前%ld%%",completed);
        
        //星星判断
        _star1ImageView.image=[[UIImage imageNamed:@"star"] imageWithColor:[UIColor lightGrayColor]];
        if(completed>=90)
        {
            _star1ImageView.image=[[UIImage imageNamed:@"star"] imageWithColor:GoldColor];
        }
        
        //按钮判断
        [_actionButton setTitle:@"完善资料" forState:UIControlStateNormal];
        
    }
}

- (IBAction)buttonClick:(id)sender {
    
    UIButton *btn=(UIButton*)sender;
    if([[btn titleForState:UIControlStateNormal] isEqualToString:@"审核中"])
    {
        [MBProgressHUD showMessag:@"信息审核中" toView:nil];
        return;
    }
    
    if(self.identifierClickBlock) self.identifierClickBlock(self.index);
}


@end
