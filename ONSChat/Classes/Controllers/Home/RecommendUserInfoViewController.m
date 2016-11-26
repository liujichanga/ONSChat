//
//  RecommendUserInfoViewController.m
//  ONSChat
//
//  Created by 王磊 on 2016/11/26.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "RecommendUserInfoViewController.h"
#import "OneVideoCell.h"

#define cellOneVideoIdentifier @"OneVideoCell"


@interface RecommendUserInfoViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RecommendUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerNib:[UINib nibWithNibName:cellOneVideoIdentifier bundle:nil] forCellReuseIdentifier:cellOneVideoIdentifier];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OneVideoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellOneVideoIdentifier forIndexPath:indexPath];
    return cell;
}
@end
