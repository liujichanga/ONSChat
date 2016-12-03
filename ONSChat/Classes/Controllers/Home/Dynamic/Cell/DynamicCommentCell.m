//
//  DynamicCommentCell.m
//  ONSChat
//
//  Created by 王磊 on 2016/11/30.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "DynamicCommentCell.h"

@interface DynamicCommentCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *diatanceLab;
@property (nonatomic, strong) UILabel *commentLab;
@end

@implementation DynamicCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(75, 50, KKScreenWidth-85, 10)];
    lab.textColor = [UIColor lightGrayColor];
    lab.font = [UIFont systemFontOfSize:15];
    lab.numberOfLines = 0;
    [self.contentView addSubview:lab];
    self.commentLab = lab;
    
    self.headImgView.layer.cornerRadius = 25.0;
    self.headImgView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setComment:(KKComment *)comment{
    _comment = comment;
    
    KKImageViewWithUrlstring(self.headImgView, comment.avatarUrl, @"def_head");
    self.nameLab.text = comment.name;
    self.diatanceLab.text = [NSString stringWithFormat:@"%@km",comment.distanceKm];
    NSString *commentText = [NSString stringWithFormat:@"[%@]",comment.commentText];
    self.commentLab.text = commentText;
    CGSize size = [commentText sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(KKScreenWidth-85, 500)];
    self.commentLab.frame = CGRectMake(75, 40, KKScreenWidth-85, size.height);
    CGFloat H = size.height +80;
    if (self.cellHeightBlock) {
        self.cellHeightBlock(H);
    }
}
@end
