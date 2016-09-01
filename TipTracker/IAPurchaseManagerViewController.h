//
//  IAPurchaseManagerViewController.h
//  myTips
//
//  Created by Michael Kozy on 6/9/16.
//  Copyright © 2016 Michael Kozy. All rights reserved.
//

#import "EditEmployerView.h"
#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import <iAd/iAd.h>

@interface IAPurchaseManagerViewController : UIViewController <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (strong, nonatomic) SKProduct *addEmployer;
@property (strong, nonatomic) NSString *productID;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *buyButton;
@property (strong, nonatomic) IBOutlet UITextView *productDescription;
@property (strong, nonatomic) EditEmployerView *purchaseEditEmployerVC;

- (void)getProductInfo:(EditEmployerView *)viewController;

@end
