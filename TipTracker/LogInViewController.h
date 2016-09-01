//
//  LogInViewController.h
//  TipTracker
//
//  Created by Michael Kozy on 3/30/16.
//  Copyright © 2016 Michael Kozy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "KeychainWrapper.h"


@interface LogInViewController : UIViewController
@property (strong, nonatomic)KeychainWrapper *keyChain;



@end
