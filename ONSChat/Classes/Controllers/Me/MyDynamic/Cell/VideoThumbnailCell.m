//
//  VideoThumbnailCell.m
//  ONSChat
//
//  Created by 王磊 on 2016/12/6.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "VideoThumbnailCell.h"

@interface VideoThumbnailCell ()

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation VideoThumbnailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setAsset:(PHAsset *)asset{
    _asset = asset;
    
    //拍摄日期
    NSDate *date = asset.creationDate;
    NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* s1 = [df stringFromDate:date];
    self.dateLabel.text = [NSString stringWithFormat:@"拍摄时间：%@",s1];
    //获取缩略图
    PHImageRequestOptions *imgOp = [[PHImageRequestOptions alloc]init];
    PHImageManager *imgManager = [PHImageManager defaultManager];
    [imgManager requestImageForAsset:asset targetSize:CGSizeMake(80, 80) contentMode:PHImageContentModeAspectFill options:imgOp resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        UIImage *img = (UIImage*)result;
        self.thumbnailImageView.image = img;
    }];
}
@end
