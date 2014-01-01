////http://blog.csdn.net/ch_soft/article/details/7702034
////  StoreKitHelper.h
////  MonsterWar
////
////  Created by nil nil on 12-8-10.
////  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//#import <StoreKit/StoreKit.h>
//
//#import "MBProgressHUD.h"
//
//@interface StoreKitHelper : NSObject <SKPaymentTransactionObserver,SKProductsRequestDelegate,UIAlertViewDelegate,MBProgressHUDDelegate> {
//
//    MBProgressHUD *HUD;
//    int _buyType;
//    SKPaymentTransaction *m_transaction;
//    
//}
// 
//+ (StoreKitHelper *)shareInstance;
//
//- (BOOL)canMakePay;
//
//-(BOOL)putStringToItunes:(NSData*)iapData;// 验证是不是发了请求，防止iap Cracker
//
//- (void)buyItemWithType:(int) tp;
//
//- (void) restoreTransaction: (SKPaymentTransaction *)transaction ;
//
//- (void) completedPurchaseTransaction: (SKPaymentTransaction *) transaction;
//
//- (void) handleFailedTransaction: (SKPaymentTransaction *) transaction;
//- (void)dismissHUD;
//-(void) finishPay;
//- (void)getAppstoreLocal;
//
//@end
