//
//  InterfaceController.h
//  BPrice WatchKit Extension
//
//  Created by Alanc Liu on 4/30/16.
//  Copyright © 2016 Alanc Liu. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "GlobalObject.h"
#import <ClockKit/ClockKit.h>
@import WatchConnectivity;

@interface InterfaceController : WKInterfaceController <WCSessionDelegate>

// Our WatchConnectivity Session for communicating with the iOS app
@property (nonatomic) WCSession* watchSession;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lbPriceUSD;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lbPrice;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lbLastTime;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *btnSwitch;
- (IBAction)BtnSwitchClick;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lbVersion;

@end
