//
//  ChatListViewController.m
//  ONSChat
//
//  Created by liujichang on 2016/11/20.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChatViewController.h"
#import "ChatListCell.h"


#define cellChatListIdentifier @"ChatListCell"

@interface ChatListViewController ()

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *topTipView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_topTipView.layer setMasksToBounds:YES];
    [_topTipView.layer setCornerRadius:3.0];
    _topView.layer.borderWidth=1.0;
    _topView.layer.borderColor=[UIColor groupTableViewBackgroundColor].CGColor;
    
    UITapGestureRecognizer *systemTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(systemTap:)];
    [self.topView addGestureRecognizer:systemTapGestureRecognizer];
    
    //使用registerNib 方法可以从XIB加载控件
    [self.tableView registerNib:[UINib nibWithNibName:cellChatListIdentifier bundle:nil] forCellReuseIdentifier:cellChatListIdentifier];
}

-(void)systemTap:(id)sender{
    
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatListCell *cell=[tableView dequeueReusableCellWithIdentifier:cellChatListIdentifier forIndexPath:indexPath];

    [cell displayInfo];
    
    return cell;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
}


@end
