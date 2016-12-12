//
//  CustomHiViewController.m
//  ONSChat
//
//  Created by liujichang on 2016/12/12.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "CustomHiViewController.h"

@interface CustomHiViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation CustomHiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //_textView.contentInset = UIEdgeInsetsMake(-78.f, 0.f, 0.f, 0.f);
    _textView.text=[KKSharedLocalPlistManager kkStringForKey:Plist_Key_CustomHi];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)customClick:(id)sender {
    
    if(KKStringIsNotBlank(_textView.text))
    {
        [KKSharedLocalPlistManager setKKValue:_textView.text forKey:Plist_Key_CustomHi];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
