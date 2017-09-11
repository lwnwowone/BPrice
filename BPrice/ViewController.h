//
//  ViewController.h
//  BPrice
//
//  Created by Alanc Liu on 4/30/16.
//  Copyright © 2016 Alanc Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
@import WatchConnectivity;

@interface ViewController : UIViewController <WCSessionDelegate>

// Our WatchConnectivity Session for communicating with the watchOS app
@property (nonatomic) WCSession* watchSession;

@end

