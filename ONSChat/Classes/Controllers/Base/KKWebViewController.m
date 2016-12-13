//
//  KKWebViewController.m
//  ONSChat
//
//  Created by liujichang on 2016/12/12.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "KKWebViewController.h"
#import <WebKit/WebKit.h>

@interface KKWebViewController ()<WKNavigationDelegate,WKUIDelegate>

@property(weak,nonatomic) WKWebView *webView;

@property(weak,nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation KKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.hidesBottomBarWhenPushed=YES;
    
    self.navigationItem.title=self.navTitle;
    
    WKWebView *webview=[[WKWebView alloc] initWithFrame:self.view.bounds];
    self.webView=webview;
    [self.view addSubview:self.webView];
    self.webView.navigationDelegate=self;
    
    UIActivityIndicatorView *indicatorview=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(200, 200, 40, 40)];
    self.activityIndicatorView=indicatorview;
    indicatorview.center=self.view.center;
    self.activityIndicatorView.hidesWhenStopped=YES;
    self.activityIndicatorView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    [self.view addSubview:self.activityIndicatorView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:KKURLWithString(self.urlStr)]];
    
    [self.activityIndicatorView startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NavDelegate
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [self.activityIndicatorView startAnimating];
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self.activityIndicatorView stopAnimating];
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [self.activityIndicatorView stopAnimating];
}




@end
