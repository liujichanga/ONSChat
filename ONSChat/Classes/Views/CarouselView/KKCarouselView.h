//
//  KKCarouselView.h
//  KuaiKuai
//
//  Created by YK on 16/4/19.
//  Copyright © 2016年 liujichang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ImagePageControl : UIPageControl

@end



@interface KKCarouselView : UIView



@property (copy, nonatomic) void(^KKCarouselViewTapBlcok)(int index);

- (void)setNetworkImageURLStr:(NSArray *)array;



@end
