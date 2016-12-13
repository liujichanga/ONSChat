//
//  VisterViewController.m
//  ONSChat
//
//  Created by liujichang on 2016/12/13.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "VisterViewController.h"
#import "VIPPayViewController.h"
#import "RecommendUserInfoViewController.h"


@interface VisterViewController ()
@property (weak, nonatomic) IBOutlet UILabel *visitInfoLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property(weak,nonatomic) UILabel *tipLabel;
@property(weak,nonatomic) ONSButtonPurple *vipButton;


@property(strong,nonatomic) NSMutableArray *arrDatas;


@end


#define TipLabelOriginY 50
#define VipButtonOriginY 100

@implementation VisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _arrDatas=[NSMutableArray array];
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, TipLabelOriginY, KKScreenWidth, 21)];
    label.text=@"升级VIP会员就可查看所有访问您的人详细资料";
    label.textColor=[UIColor darkGrayColor];
    label.textAlignment=NSTextAlignmentCenter;
    self.tipLabel=label;
    [self.scrollView addSubview:label];
    
    ONSButtonPurple *btn=[ONSButtonPurple ONSButtonWithTitle:@"开通VIP查看更多数据" frame:CGRectMake(30, VipButtonOriginY, KKScreenWidth-60, 35)];
    [btn addTarget:self action:@selector(gotoVip:) forControlEvents:UIControlEventTouchUpInside];
    self.vipButton =btn;
    [self.scrollView addSubview:btn];
    
    [self loadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData
{
    [_arrDatas removeAllObjects];
    //清理界面
    NSArray *viewsarr=self.scrollView.subviews;
    for (UIView *view in viewsarr) {
        if(view.tag>=500)
            [view removeFromSuperview];
    }
    
    //读取数据
    [SVProgressHUD show];
    [FSSharedNetWorkingManager POST:ServiceInterfaceVisit parameters:@{@"currentPage":@(0),@"limit":@(40)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic=(NSDictionary*)responseObject;
        KKLog(@"visit:%@",dic);
        NSInteger status = [dic integerForKey:@"status" defaultValue:0];
        if(status==1)
        {
            [SVProgressHUD dismiss];
            NSArray *arr=[dic objectForKey:@"aaData"];
            if(arr&&[arr isKindOfClass:[NSArray class]])
            {
                [_arrDatas addObjectsFromArray:arr];
                
                [self loadImageViews];
                
                //label
                NSString *str=KKStringWithFormat(@"共有%ld人查看了我的主页",_arrDatas.count);
                NSRange rang=NSMakeRange(2, KKStringWithFormat(@"%ld",_arrDatas.count).length);
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
                [attributedString addAttribute:NSForegroundColorAttributeName value:KKColorPurple range:rang];
                
                _visitInfoLabel.attributedText=attributedString;
            }
        }
        else
        {
            [SVProgressHUD dismissWithError:[dic stringForKey:@"statusMsg" defaultValue:@"读取失败"] afterDelay:2.0];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismissWithError:KKErrorInfo(error) afterDelay:2.0];
    }];
}

-(void)loadImageViews
{
    CGFloat interval=10.0;
    CGFloat imagewidth = (KKScreenWidth-5*interval)/4.0;
    
    CGFloat contentHeight = 0;
    
    for (int i=0; i<self.arrDatas.count; i++) {
        
        NSInteger val=i/4;
        NSInteger mod=i%4;
        
        CGFloat originx=interval+(imagewidth+interval)*mod;
        CGFloat originy=interval+(imagewidth+interval)*val;
        
        UIImageView *imageview=[[UIImageView alloc] initWithFrame:CGRectMake(originx, originy, imagewidth, imagewidth)];
        imageview.contentMode=UIViewContentModeScaleAspectFill;
        imageview.clipsToBounds=YES;
        imageview.tag=500+i;
        imageview.userInteractionEnabled=YES;
        [self.scrollView addSubview:imageview];
        
        UITapGestureRecognizer *imageGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
        [imageview addGestureRecognizer:imageGestureRecognizer];
        
        NSDictionary *dic=self.arrDatas[i];
        NSString *url=[dic stringForKey:@"avatar" defaultValue:@""];
        if(KKStringIsNotBlank(url))
            KKImageViewWithUrlstring(imageview, url, @"def_head");
        
        contentHeight=originy+(imagewidth+interval);
    }
    
    self.tipLabel.frame=KKFrameOfOriginY(self.tipLabel.frame, contentHeight +TipLabelOriginY);
    self.vipButton.frame=KKFrameOfOriginY(self.vipButton.frame, contentHeight + VipButtonOriginY);
    
    self.scrollView.contentSize=CGSizeMake(KKScreenWidth, contentHeight);
}

-(void)gotoVip:(id)sender{
    
    VIPPayViewController *vipVC=KKViewControllerOfMainSB(@"VIPPayViewController");
    [self.navigationController pushViewController:vipVC animated:YES];
    
    [MobClick event:@"025"];
}

-(void)imageTap:(UITapGestureRecognizer *)tapGesture{
    NSInteger tag=tapGesture.view.tag;
    tag-=500;
    if(KKSharedCurrentUser.isVIP)
    {
        NSDictionary *dic=self.arrDatas[tag];
        RecommendUserInfoViewController *recommendUser = KKViewControllerOfMainSB(@"RecommendUserInfoViewController");
        recommendUser.uid = [dic stringForKey:@"id" defaultValue:@""];
        recommendUser.dynamicsID=[dic stringForKey:@"dynamicsId" defaultValue:@""];
        [self.navigationController pushViewController:recommendUser animated:YES];
    }
    else
    {
        [self gotoVip:nil];
    }
}


@end
