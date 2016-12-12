//
//  HonestyViewController.m
//  ONSChat
//
//  Created by liujichang on 2016/12/12.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "HonestyViewController.h"
#import "IdentifierViewController.h"
#import "IdentifierCell.h"
#import "HonestBottomCell.h"
#import "BindingPhoneNumberViewController.h"
#import "MyPhotoViewController.h"
#import "MyInfoViewController.h"



#define cellIdentifierIdentifier @"IdentifierCell"
#define cellHonestBottomIdentifier @"HonestBottomCell"


#define GoldColor [UIColor colorWithRed:254.0/255.0 green:211.0/255.0 blue:85.0/255.0 alpha:1.0]




@interface HonestyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *start1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *start2ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *start3ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *start4ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *start5ImageView;


@property(strong,nonatomic) NSMutableArray *arrDatas;

@end



@implementation HonestyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _arrDatas=[NSMutableArray array];
    
    [self.tableView registerNib:[UINib nibWithNibName:cellIdentifierIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifierIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:cellHonestBottomIdentifier bundle:nil] forCellReuseIdentifier:cellHonestBottomIdentifier];

    [self loadStar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadStar];
}

-(void)loadStar
{
    NSInteger startcount=0;
    if(KKSharedCurrentUser.isPhone) startcount+=1;
    if([KKSharedGlobalManager getPhotosCount]>=3) startcount+=1;
    //判断资料完整度
    NSInteger complete=[KKSharedGlobalManager infoCompletedPercent];
    if(complete>=90) startcount+=1;

    
    _start1ImageView.image=[[UIImage imageNamed:@"star"] imageWithColor:[UIColor lightGrayColor]];
    _start2ImageView.image=[[UIImage imageNamed:@"star"] imageWithColor:[UIColor lightGrayColor]];
    _start3ImageView.image=[[UIImage imageNamed:@"star"] imageWithColor:[UIColor lightGrayColor]];
    _start4ImageView.image=[[UIImage imageNamed:@"star"] imageWithColor:[UIColor lightGrayColor]];
    _start5ImageView.image=[[UIImage imageNamed:@"star"] imageWithColor:[UIColor lightGrayColor]];
    if(startcount==3)
    {
        _start1ImageView.image=[[UIImage imageNamed:@"star"] imageWithColor:GoldColor];
        _start2ImageView.image=[[UIImage imageNamed:@"star"] imageWithColor:GoldColor];
        _start3ImageView.image=[[UIImage imageNamed:@"star"] imageWithColor:GoldColor];
    }
    else if(startcount==2)
    {
        _start1ImageView.image=[[UIImage imageNamed:@"star"] imageWithColor:GoldColor];
        _start2ImageView.image=[[UIImage imageNamed:@"star"] imageWithColor:GoldColor];
    }
    else if(startcount==1)
    {
        _start1ImageView.image=[[UIImage imageNamed:@"star"] imageWithColor:GoldColor];
    }
    
    [self.tableView reloadData];

}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==4) return 220;
    else return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row==4)
    {
        HonestBottomCell *cell=[tableView dequeueReusableCellWithIdentifier:cellHonestBottomIdentifier forIndexPath:indexPath];
        return cell;
    }
    else
    {
        IdentifierCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifierIdentifier forIndexPath:indexPath];
        
        [cell showDisplayInfo:indexPath.row];
        
        KKWEAKSELF;
        cell.identifierClickBlock=^(NSInteger index){
            
            if(index==0)
            {
                IdentifierViewController *identifierVC=KKViewControllerOfMainSB(@"IdentifierViewController");
                [weakself.navigationController pushViewController:identifierVC animated:YES];
            }
            else if(index==1)
            {
                BindingPhoneNumberViewController *bindVC=KKViewControllerOfMainSB(@"BindingPhoneNumberViewController");
                [weakself.navigationController pushViewController:bindVC animated:YES];
            }
            else if(index==2)
            {
                MyPhotoViewController *myphotoVC=KKViewControllerOfMainSB(@"MyPhotoViewController");
                [weakself.navigationController pushViewController:myphotoVC animated:YES];
            }
            else if(index==3)
            {
                MyInfoViewController *myinfoVC=KKViewControllerOfMainSB(@"MyInfoViewController");
                [weakself.navigationController pushViewController:myinfoVC animated:YES];
            }

            
        };
        
        return  cell;

    }
    
}


@end
