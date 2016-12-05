//
//  DynamicCell.m
//  ONSChat
//
//  Created by 王磊 on 2016/11/30.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "DynamicCell.h"

@interface DynamicCell()

@property (nonatomic, strong) KRVideoPlayerController *videoController;
@property (nonatomic, strong) UILabel *videoStrLab;
@property (nonatomic, assign) CGFloat height;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *infoLab;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *conmentBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;


@property (nonatomic, strong) UIView *bgView;
@end

@implementation DynamicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, KKScreenWidth-20, 10)];
    lab.font = [UIFont systemFontOfSize:15];
    lab.numberOfLines = 0;
    [self.contentView addSubview:lab];
    self.videoStrLab = lab;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDynamic:(KKDynamic *)dynamic{
    _dynamic = dynamic;
    if (self.allowLike==YES) {
        self.likeBtn.enabled = YES;
        self.conmentBtn.enabled = YES;

    }else{
        self.likeBtn.enabled = NO;
        self.conmentBtn.enabled = NO;
        
    }
    
    KKImageViewWithUrlstring(self.headImageView, dynamic.avatarUrl, @"def_head");
    self.nameLab.text = dynamic.nickName;
    self.infoLab.text = [NSString stringWithFormat:@"%zd岁  %zdcm",dynamic.age,dynamic.height];
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%zd",dynamic.praiseNum] forState:UIControlStateNormal];
    [self.conmentBtn setTitle:[NSString stringWithFormat:@"%zd",dynamic.commentNum] forState:UIControlStateNormal];
    
    NSString *videoStr = dynamic.dynamicText;
    NSString *dynamicUrl;
    //我的动态列表 加载本地数据
    if (self.local==YES) {
        if (self.allowLike==NO) {
            //我的动态列表
            self.deleteBtn.hidden = NO;
            self.infoLab.hidden = YES;

        }else{
            //我的动态详情
            self.infoLab.hidden = NO;
            self.infoLab.text = [NSString stringWithFormat:@"%zd岁  %zdcm",KKSharedCurrentUser.age,KKSharedCurrentUser.height];
        }
        
        self.nameLab.text = KKSharedCurrentUser.nickName;
        KKImageViewWithUrlstring(self.headImageView, KKSharedCurrentUser.avatarUrl, @"def_head");
        dynamicUrl = [NSString stringWithFormat:@"file://%@",dynamic.dynamicUrl];

    }else{
        dynamicUrl = dynamic.dynamicUrl;
    }
    NSString *imgURL = dynamic.dynamiVideoThumbnail;
    
    CGSize strSize = [videoStr sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(KKScreenWidth-20, 500)];
    self.videoStrLab.text = videoStr;
    self.videoStrLab.frame = CGRectMake(10, 70, KKScreenWidth-20, strSize.height);
    
    if (self.bgView) {
        [self.bgView removeFromSuperview];
    }
    
    if (dynamic.dynamicsType ==KKDynamicsTypeImage) {
        //图片frame可根据需要修改
        self.bgView = [[UIView alloc]initWithFrame:CGRectMake(10, self.videoStrLab.frame.origin.y+self.videoStrLab.frame.size.height+10, KKScreenWidth*0.5, KKScreenWidth*0.5)];
//        self.bgView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.bgView];
        
        UIImageView *dynamicsImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bgView.frame), CGRectGetHeight(self.bgView.frame))];
        dynamicsImgView.userInteractionEnabled = YES;
        KKImageViewWithUrlstring(dynamicsImgView, dynamicUrl, @"");
        dynamicsImgView.backgroundColor = [UIColor clearColor];
        dynamicsImgView.contentMode = UIViewContentModeScaleAspectFit;

        [self.bgView addSubview:dynamicsImgView];
        self.height = self.bgView.frame.origin.y+self.bgView.frame.size.height+45;
        
    }else{
        self.bgView = [[UIView alloc]initWithFrame:CGRectMake(10, self.videoStrLab.frame.origin.y+self.videoStrLab.frame.size.height+10, KKScreenWidth-20, (KKScreenWidth-20)*(9.0/16.0))];
//        self.bgView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.bgView];
        
        self.videoController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bgView.frame), CGRectGetHeight(self.bgView.frame)) andImageURL:imgURL andVideoURL:dynamicUrl];
        self.videoController.repeatMode = MPMovieRepeatModeNone;
        [self.videoController showInView:self.bgView];
        self.height = self.bgView.frame.origin.y+self.bgView.frame.size.height+45;
    }
    
    if (self.cellHeightBlock) {
        self.cellHeightBlock(self.height);
    }
}
- (IBAction)likeBtnClick:(UIButton*)sender {
    if (self.local==NO) {
        if (sender.selected==YES) {
            return;
        }
        sender.selected = YES;
        [sender setTitle:[NSString stringWithFormat:@"%zd",_dynamic.praiseNum+1] forState:UIControlStateSelected];
        
        NSDictionary *userInfo = @{@"pariseNum":@(_dynamic.praiseNum+1)};
        [KKNotificationCenter postNotificationName:@"updatePraiseNub" object:nil userInfo:userInfo];
        
        if (self.praiseBlock) {
            self.praiseBlock();
        }
    }
}

- (IBAction)conmentBtnClick:(id)sender {
    if (self.local==NO) {
        if (self.conmentBlock) {
            self.conmentBlock();
        }
    }
}
- (IBAction)deleteBtnClick:(id)sender {
    if (self.deleteBlock) {
        self.deleteBlock(self.dynamic.dynamicsId);
    }
    
}

@end
