//
//  HomeViewController.m
//  ONSChat
//
//  Created by liujichang on 2016/11/21.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "HomeViewController.h"
#import "TwoPicCell.h"
#import "OneVideoCell.h"

#define cellTwoPicIdentifier @"TwoPicCell"
#define cellOneVideoIdentifier @"OneVideoCell"


@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //使用registerNib 方法可以从XIB加载控件
    [self.tableView registerNib:[UINib nibWithNibName:cellTwoPicIdentifier bundle:nil] forCellReuseIdentifier:cellTwoPicIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:cellOneVideoIdentifier bundle:nil] forCellReuseIdentifier:cellOneVideoIdentifier];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TwoPicCell *cell=[tableView dequeueReusableCellWithIdentifier:cellTwoPicIdentifier forIndexPath:indexPath];
    
    return cell;
    
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
}

@end
