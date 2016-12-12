//
//  FSStore.m
//  ONSChat
//
//  Created by liujichang on 2016/12/9.
//  Copyright © 2016年 LiuJichang. All rights reserved.
//

#import "FSStore.h"
#import <StoreKit/StoreKit.h>

@interface FSStore()<SKRequestDelegate,SKProductsRequestDelegate,SKPaymentTransactionObserver>

@property(strong,nonatomic) NSString *productId;

@end

@implementation FSStore

-(instancetype)init{
    if(self=[super init])
    {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

-(void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    KKLog(@"FSStore dealloc");
}

-(BOOL)canPayment{
    if ([SKPaymentQueue canMakePayments]) {
        return YES;
    } else {
        [SVProgressHUD showErrorWithStatus:@"用户禁止应用内付费购买" duration:2.0];
        return NO;
    }
}

-(void)buyProduct:(NSString*)productId{
    self.productId=productId;
    NSArray *product = [[NSArray alloc] initWithObjects:productId, nil];
    NSSet *set = [NSSet setWithArray:product];
    SKProductsRequest * request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
    [SVProgressHUD showWithStatus:@"正在购买，请稍后"];
}

#pragma amrk - SKProductsRequestDelegate
// 查询成功后的回调
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    [SVProgressHUD dismiss];
    NSArray *myProduct = response.products;
    if (myProduct.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"无法获取产品信息，请重试" duration:2.0];
        return;
    }
    SKPayment * payment = [SKPayment paymentWithProduct:myProduct[0]];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//查询失败后的回调
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"request error:%@",error);
    [SVProgressHUD dismissWithError:@"购买失败，请稍后重试" afterDelay:2.0];
}

#pragma mark -SKPaymentQueueDelegate
//购买操作后的回调
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    [SVProgressHUD dismiss];
    for (SKPaymentTransaction *transaction in transactions)
    {
        NSLog(@"transactionState:%ld",transaction.transactionState);
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased://交易完成
                [self completeTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed://交易失败
                [self failedTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateRestored://已经购买过该商品
                [SVProgressHUD showWithStatus:@"恢复购买成功"];
                [self restoreTransaction:transaction];
                break;
                
            case SKPaymentTransactionStatePurchasing://商品添加进列表
                [SVProgressHUD showWithStatus:@"正在请求付费信息，请稍后"];
                break;
                
            default:
                break;
        }
    }
    
}


- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    NSLog(@"complete");
    [SVProgressHUD dismiss];
    if(_delegate) [_delegate buySucceed:self.productId];
}


- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    if(transaction.error.code != SKErrorPaymentCancelled) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"购买失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    } else {
       
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

@end
