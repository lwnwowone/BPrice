//
//  InterfaceController.m
//  BPrice WatchKit Extension
//
//  Created by Alanc Liu on 4/30/16.
//  Copyright © 2016 Alanc Liu. All rights reserved.
//

#import "InterfaceController.h"
#import <WatchConnectivity/WatchConnectivity.h>

@implementation InterfaceController

NSTimer *timer;
NSString *priceCNY = @"priceCNY";
//NSString *lastCNY = @"lastCNY";
NSString *priceUSD = @"priceUSD";
//NSString *lastUSD = @"lastUSD";

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    [self.lbPriceUSD setWidth:[WKInterfaceDevice currentDevice].screenBounds.size.width];
    [self.lbPrice setWidth:[WKInterfaceDevice currentDevice].screenBounds.size.width];
    //    [self.lbChange setWidth:[WKInterfaceDevice currentDevice].screenBounds.size.width];
    [self.lbLastTime setWidth:[WKInterfaceDevice currentDevice].screenBounds.size.width];
    [self.btnSwitch setWidth:[WKInterfaceDevice currentDevice].screenBounds.size.width];
    [self.lbVersion setWidth:[WKInterfaceDevice currentDevice].screenBounds.size.width];
    
    [self.lbLastTime setHeight:20];
    [self.btnSwitch setHeight:30];
    [self.lbVersion setHeight:20];

    float screenHeight = [WKInterfaceDevice currentDevice].screenBounds.size.height;
    float lbHeight = (screenHeight-108)/2;
    [self.lbPriceUSD setHeight:lbHeight];
    [self.lbPrice setHeight:lbHeight];
    
    NSString *versionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [self.lbVersion setText:[NSString stringWithFormat:@"Version %@",versionStr]];
    [self.lbPriceUSD setText:@"Loading"];
    [self.lbPrice setText:@"Loading"];
//    [self.lbChange setText:@"Loading"];
    [self.lbLastTime setText:@"Loading"];
    if ([GlobalObject nowCNY])
        [self.btnSwitch setTitle:@"Show USD"];
    else
        [self.btnSwitch setTitle:@"Show CNY"];

    [self.btnSwitch setBackgroundColor:[UIColor grayColor]];
    
    if([WCSession isSupported]){
        self.watchSession = [WCSession defaultSession];
        self.watchSession.delegate = self;
        [self.watchSession activateSession];
    }
}

- (void) session:(WCSession *)session didReceiveApplicationContext:(NSDictionary<NSString *,id> *)applicationContext {
    NSString* message = [applicationContext objectForKey:@"message"];
    NSLog([NSString stringWithFormat:@"message = %@",message]);
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [GlobalObject getCurrentPriceRunWithAciton:self andSelector:@selector(doSomeThingWithObject:)];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    NSLog(@"didDeactivate");
    [timer invalidate];
    [GlobalObject refreshComplications];
}

-(void)timerFired{
    NSLog(@"timer do");
    [GlobalObject getCurrentPriceRunWithAciton:self andSelector:@selector(doSomeThingWithObject:)];
}

-(void)doSomeThingWithObject:(NSDictionary *)infoDic{
    NSString *nowPrice = @"";
    NSString *lastPrice = @"";
    
    priceCNY = [infoDic valueForKey:@"priceCNY"];
//    lastCNY = [infoDic valueForKey:@"lastCNY"];
    priceUSD = [infoDic valueForKey:@"priceUSD"];
//    lastUSD = [infoDic valueForKey:@"lastUSD"];

    [self setDisplayValueWithCurrentCNYPrice:priceCNY andCurrentUSDPrice:priceUSD];
}

-(void)setDisplayValueWithCurrentCNYPrice:(NSString *)CNYPrice andCurrentUSDPrice:(NSString *)USDPrice
{
    NSLog(@"setDisplayValueWithCurrentPrice");
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd hh:mm:ss"];
    date = [formatter stringFromDate:[NSDate date]];
    
//    NSString *changeStr = @"+0.00";
//    
//    if(lastPrice.floatValue>0){
//        float changeValue = currentPrice.floatValue - lastPrice.floatValue;
//        changeStr = [NSString stringWithFormat:@"%.2f",changeValue];
//        if (changeValue>=0) {
//            changeStr = [NSString stringWithFormat:@"+%@",changeStr];
//        }
//    }
    
    NSNumberFormatter *priceFormatter = [[NSNumberFormatter alloc] init];
    priceFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSString *cnyPrice = [priceFormatter stringFromNumber:[NSNumber numberWithFloat:priceCNY.floatValue]];
    NSString *usdPrice = [priceFormatter stringFromNumber:[NSNumber numberWithFloat:priceUSD.floatValue]];
    NSString *disPartC = [NSString stringWithFormat:@"¥%@",cnyPrice];
    NSString *disPartU = [NSString stringWithFormat:@"$%@",usdPrice];
    
    [self.lbPrice setText:disPartC];
    [self.lbPriceUSD setText:disPartU];
    [self.lbLastTime setText:date];
}

//-(void)switchCurrency:(NSString *)currentPrice andLastPrice:(NSString *)lastPrice{
//    NSLog(@"setDisplayValueWithCurrentPrice");
//    NSString* date;
//    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"MM-dd hh:mm:ss"];
//    date = [formatter stringFromDate:[NSDate date]];
//    
//    NSString *changeStr = @"......";
//
//    NSNumberFormatter *priceFormatter = [[NSNumberFormatter alloc] init];
//    priceFormatter.numberStyle = NSNumberFormatterDecimalStyle;
//
//    NSString *cnyPrice = [priceFormatter stringFromNumber:[NSNumber numberWithFloat:priceCNY.floatValue]];
//    NSString *usdPrice = [priceFormatter stringFromNumber:[NSNumber numberWithFloat:priceUSD.floatValue]];
//    
//    NSString *displayPrice = @"";
//    if ([GlobalObject nowCNY])
//        displayPrice = [NSString stringWithFormat:@"¥%@",cnyPrice];
//    else
//        displayPrice = [NSString stringWithFormat:@"$%@",usdPrice];
//    
//    [self.lbPrice setText:displayPrice];
//    [self.lbChange setText:changeStr];
//}

- (IBAction)BtnSwitchClick {
    NSLog(@"BtnSwitchClick");
    [GlobalObject setNowCNY:![GlobalObject nowCNY]];
    if ([GlobalObject nowCNY]) {
        [self.btnSwitch setTitle:@"Show CNY"];
//        [self switchCurrency:priceUSD andLastPrice:lastUSD];
    }
    else{
        [self.btnSwitch setTitle:@"Show USD"];
//        [self switchCurrency:priceCNY andLastPrice:lastCNY];
    }
    [GlobalObject refreshComplications];
}
@end




