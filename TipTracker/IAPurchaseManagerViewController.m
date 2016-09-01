//
//  IAPurchaseManagerViewController.m
//  myTips
//
//  Created by Michael Kozy on 6/9/16.
//  Copyright © 2016 Michael Kozy. All rights reserved.
//


#import "IAPurchaseManagerViewController.h"

@interface IAPurchaseManagerViewController ()

@end

@implementation IAPurchaseManagerViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)getProductInfo:(EditEmployerView *)viewController {
    _purchaseEditEmployerVC = viewController;
    if ([SKPaymentQueue canMakePayments]) {
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:self.productID]];
        request.delegate = self;
        [request start];
    }else {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please enable in app purchases in device settings" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.tabBarController setSelectedIndex:0];
        }];
        [controller addAction:okAction];
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self unlockFeature];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"Transaction Failed");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;

            default:
                break;
        }
    }
}


- (void)unlockFeature {
    [self.tabBarController.tabBarItem isEnabled];
}


- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *product = response.products;
    if (product.count != 0) {
        _addEmployer = product[0];
    }
    else {
        NSLog(@"Feature not found");
    }
}

@end
