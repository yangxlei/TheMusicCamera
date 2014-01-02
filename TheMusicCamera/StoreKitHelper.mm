////
////  StoreKitHelper.m
////  MonsterWar
////
////  Created by nil nil on 12-8-10.
////  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
////
//
//#import "StoreKitHelper.h"
//
////#import "RootViewController.h"
////#import "AppController.h"
//
////#import "NSString+SBJSON.h"
////#import "NSData+Base64.h"
////#import "SBJson.h"
////
////#import "ASIHTTPRequest.h"
////#import "ASIFormDataRequest.h"
////#include "AppStorePayment.h"
//
//@implementation StoreKitHelper
//
//static StoreKitHelper *storeKitHelperInstance;
//
//+ (StoreKitHelper *)shareInstance {
//    
//    if (!storeKitHelperInstance) {
//        storeKitHelperInstance = [[StoreKitHelper alloc] init];
//    }
//    
//    return storeKitHelperInstance;
//}
//
//- (id)init {
//
//    if ((self = [super init])) {
//        //----监听购买结果
//        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
//        m_transaction=Nil;
//    }
//    
//    return self;
//}
//
//- (BOOL)canMakePay{
//
//    return [SKPaymentQueue canMakePayments];
//}
//
//-(BOOL)putStringToItunes:(NSData*)iapData {
//    
//    
//   NSString *encodingStr =  [iapData base64EncodedString];
//    
//#if DEBUG
//    NSString* URL = @"https://sandbox.itunes.apple.com/verifyReceipt";//
//#else
//    NSString* URL = @"https://buy.itunes.apple.com/verifyReceipt";
//#endif
//
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:URL]];
//    NSLog(@"url=%@",URL);
//    [request setHTTPMethod:@"POST"];
//     
//    //设置contentType
//    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    
//    //设置Content-Length
//    [request setValue:[NSString stringWithFormat:@"%d", [encodingStr length]]  forHTTPHeaderField:@"Content-Length"];
//    
//    NSDictionary* body = [NSDictionary dictionaryWithObjectsAndKeys:encodingStr, @"receipt-data", nil];
//
//    SBJsonWriter *writer = [SBJsonWriter new];
//    
//    [request setHTTPBody:[[writer stringWithObject:body] dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
//    
//    NSHTTPURLResponse *urResponse = nil;
//    NSError *errorrr = nil;
//    
//    NSData *recivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urResponse error:&errorrr];
//    
//    //解析
//    NSString *results=[[NSString alloc]initWithBytes:[recivedData bytes] length:[recivedData length] encoding:NSUTF8StringEncoding];
//        
//    NSDictionary *dic = [results JSONValue];
//    
//    if([[dic objectForKey:@"status"] intValue]==0){//注意，status=@"0" 是验证收据成功
//        return true;
//    }
//    return false;
//}
//
//- (void)buyItemWithType:(int) tp {
//
//    if (HUD) {
//        return;
//    }
//    
//    _buyType = tp;
//    
//    NSString *product;
//    if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.lvmax.appstore.tank"]) {
//        product = [NSString stringWithFormat:@"tk_gold_%d",tp];
//    }
//    else{
//        product = [NSString stringWithFormat:@"tk_gold_%d",tp];
//    }
//
//    
//    SKPayment *payment = [SKPayment paymentWithProductIdentifier:product];
//    [[SKPaymentQueue defaultQueue] addPayment:payment];
//    
////    RootViewController *rootViewControll = [AppController shareRootViewController];
////    
////    HUD = [[MBProgressHUD alloc] initWithView:rootViewControll.view];
////	[rootViewControll.view addSubview:HUD];
//	
////	HUD.delegate = self;
////	HUD.labelText = @"Loading";
////    HUD.dimBackground = YES;
////	
//////	[HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
////    [HUD show:YES];
//
//}
//
//- (void) restoreTransaction: (SKPaymentTransaction *)transaction    
//{
//    NSLog(@" 交易恢复处理");    
//    
//}
//
//- (void) completeTransaction: (SKPaymentTransaction *)transaction    
//{
//    NSLog(@"-----completeTransaction--------");
//    // Your application should implement these two methods.
//    NSString *product = transaction.payment.productIdentifier;
//    
//    if ([self putStringToItunes:transaction.transactionReceipt]) {
//        
//        
//    
//    }
//    else {
//        UIAlertView *alertView =  [[UIAlertView alloc] initWithTitle: nil
//                                                             message: @"失败"
//                                                            delegate: nil
//                                                   cancelButtonTitle: @"OK"
//                                                   otherButtonTitles: nil];
//        [alertView autorelease];
//        [alertView show];
//    }
//   
//    // Remove the transaction from the payment queue.
//    m_transaction=transaction;
//    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
//    
//    [self dismissHUD];
//    
//}
//
//
//
//////记录交易
////-(void)reco:(NSString *)product{
////    NSLog(@"-----记录交易--------");
////}    
////
//////处理下载内容
////-(void)provideContent:(NSString *)product{
////    NSLog(@"-----下载--------");
////    
////    int length = [product length];
////    int t = [[product substringWithRange:NSMakeRange(length-1, 1)] intValue];
////    
////    //TODO: 购买成功处理
////
////    
////}
////-(void) finishPay
////{
////    if (m_transaction)
////    {
////        [[SKPaymentQueue defaultQueue] finishTransaction: m_transaction];
////    }
////    m_transaction=Nil;
////    
////    
////}
////弹出错误信息
//- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
////    NSLog(@"-------弹出错误信息----------");
////    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@"error" message:[error localizedDescription]
////                                                       delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
////    [alerView show];
////    [alerView release];
//}
//
//#pragma mark - SKPaymentTransactionObserver -
//
//- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
//
//    for (SKPaymentTransaction *transaction in transactions) {
//		switch (transaction.transactionState) {
//            case SKPaymentTransactionStatePurchasing:
//                NSLog(@"SKPaymentTransactionStatePurchasing");
//                break;
//			case SKPaymentTransactionStatePurchased: 
//                [self completeTransaction:transaction];
//                break;
//			case SKPaymentTransactionStateRestored: 
//				[self completedPurchaseTransaction:transaction];
//				break;
//			case SKPaymentTransactionStateFailed: 
//				[self handleFailedTransaction:transaction]; 
//				break;
//			default: 
//                NSLog(@"other");
//				break;
//		}
//	}
//}
//
//- (void) completedPurchaseTransaction: (SKPaymentTransaction *) transaction
//{
//	// PERFORM THE SUCCESS ACTION THAT UNLOCKS THE FEATURE HERE
//    
//	// Finish transaction
//	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
//    m_transaction=transaction;
//    [self dismissHUD];
//    NSLog(@"Thank you for your purchase.");
//}
//
//- (void) handleFailedTransaction: (SKPaymentTransaction *) transaction
//{
//    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@"error" message:transaction.error.description delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];    
//    
//    [alerView show];
//    [alerView release];
//    
//    NSString *encodingStr = [[[NSString alloc] initWithData:transaction.transactionReceipt encoding:NSUTF8StringEncoding] autorelease];
//    //NSLog(@"哈哈哈%@",encodingStr);
//    switch (transaction.error.code) {
//        case SKErrorUnknown:
//            NSLog(@"SKErrorUnknown");
//            break;
//        case SKErrorClientInvalid:
//            NSLog(@"SKErrorClientInvalid");
//            break;
//        case SKErrorPaymentInvalid:
//            NSLog(@"SKErrorPaymentInvalid");
//            break;
//        case SKErrorPaymentCancelled:
//            NSLog(@"SKErrorPaymentCancelled");
//            break;
//        case SKErrorPaymentNotAllowed:
//            NSLog(@"SKErrorPaymentNotAllowed");
//        default:
//            break;
//    }
//    if (transaction.error.code != SKErrorPaymentCancelled) {
//        UIAlertView *alertView =  [[UIAlertView alloc] initWithTitle: nil
//                                                             message:@"购买失败"
//                                                            delegate: nil
//                                                   cancelButtonTitle: @"OK"
//                                                   otherButtonTitles: nil];
//        [alertView autorelease];
//        [alertView show];
//        [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
//    }
//	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
//    m_transaction=transaction;
//    
//    [self dismissHUD];
//}
//- (void)getAppstoreLocal
//{
//    NSLog(@"------请求升级数据---------");
//    NSSet *productIdentifiers = [NSSet setWithObject:@"tk_gold_1"];
//    SKProductsRequest* productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
//    productsRequest.delegate = self;
//    [productsRequest start];
//    
//}
//
//#pragma mark - SKProductsRequestDelegate -
//- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
//    
//    SKProduct *buyId = [response.products lastObject];
//    
//    if (!buyId) {
//        NSLog(@"error xxxxx");
//    }
//    
//    NSLog(@"-----------收到产品反馈信息--------------");
//    NSArray *myProduct = response.products;
//    NSLog(@"无效Product ID:%@",response.invalidProductIdentifiers);
//    NSLog(@"正常产品付费数量: %d", [myProduct count]);
//    // populate UI
//    for(SKProduct *product in myProduct){
//        NSLog(@"product info");
//        NSLog(@"SKProduct 描述信息%@", [product description]);
//        NSLog(@"产品标题 %@" , product.localizedTitle);
//        NSLog(@"产品描述信息: %@" , product.localizedDescription);
//        NSLog(@"价格: %@" , product.price);
//        NSLog(@"Product id: %@" , product.productIdentifier);
//        NSLog(@"当前币种: %@" , [product.priceLocale localeIdentifier]);
//        NSString *moneyType=[product.priceLocale localeIdentifier];
////        const char *charMoneyType= [moneyType UTF8String];
////        AppStorePayment::shared()->setMoneyType(charMoneyType);
//        
//    }
//
//}
//
//#pragma mark -
//#pragma mark MBProgressHUDDelegate methods
//
//- (void)hudWasHidden:(MBProgressHUD *)hud {
//	// Remove HUD from screen when the HUD was hidded
//	[HUD removeFromSuperview];
//	[HUD release];
//	HUD = nil;
//}
//
//#pragma mark -
//
//- (void)dismissHUD {
//
//    if (!HUD) {
//        return;
//    }
//    
//    [HUD removeFromSuperview];
//	[HUD release];
//	HUD = nil;
//    
//}
//
//-(void)dealloc
//{
//    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];//解除监听
//    [super dealloc];
//}
//
//@end
