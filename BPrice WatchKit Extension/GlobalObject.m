//
//  GlobalObject.m
//  PriceAss
//
//  Created by Alanc Liu on 4/26/16.
//  Copyright © 2016 Alanc Liu. All rights reserved.
//

#import "GlobalObject.h"

@implementation GlobalObject

NSString *nowCNYPrice = @"0";
NSString *nowUSDPrice = @"0";
bool getFlag = NO;
bool isNowCNY;

+(NSDictionary *)getNowPrice{
    NSDictionary *tmp;
    if (getFlag) {
        tmp = [NSDictionary dictionaryWithObjectsAndKeys:
           nowCNYPrice, @"priceCNY",
           nowUSDPrice, @"priceUSD",
           nil];
        getFlag = NO;
        NSLog(@"Return price");
        [self performSelector:@selector(changeFlag) withObject:nil afterDelay:5];
    }
    return tmp;
}

+(void)changeFlag{
    NSLog(@"Stop return price");
    getFlag = NO;
}

+(void)refreshComplications{
    getFlag = YES;
    CLKComplicationServer *server = [CLKComplicationServer sharedInstance];
    for (CLKComplication *com in server.activeComplications) {
        [server reloadTimelineForComplication:com];
    }
}

+(BOOL)nowCNY{
    bool flag = [[NSUserDefaults standardUserDefaults] boolForKey:@"isNowCNY"];
    return flag;
}

+(void)setNowCNY:(BOOL)flag{
//    isNowCNY = flag;
    [[NSUserDefaults standardUserDefaults] setBool:flag forKey:@"isNowCNY"];
}

+(NSString *)currentURL{
//    return @"https://data.btcc.com/data/ticker";
    return @"https://pro-data.btcc.com/data/udf/quotes?symbols=bpicny,bpiusd";
//    return @"https://api.bitcoinaverage.com/ticker/all";
}

NSString *lastDataStr = @"";

+(void)getCurrentPriceRunWithAciton:(id)target andSelector:(SEL)oneSelector{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    
    NSString *urlPath = [NSString stringWithFormat:@"%@&%@",[GlobalObject currentURL],timeString];
    NSURL *url = [NSURL URLWithString:urlPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:120];
    [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"]; //告诉服务,返回的数据需要压缩
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if([dataStr isEqualToString:lastDataStr])
                NSLog(@"It's the same.");
            else
                NSLog(@"It's different.");
            lastDataStr = dataStr;
            
            NSData* jsonData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
            NSArray *dArr = [dic valueForKey:@"d"];
            
            NSDictionary *dicDetailCNY = [dArr objectAtIndex:0];
            NSDictionary *dicCNY = [dicDetailCNY valueForKey:@"v"];
            
            
            NSDictionary *dicDetailUSD = [dArr objectAtIndex:1];
            NSDictionary *dicUSD = [dicDetailUSD valueForKey:@"v"];
            
            NSString *priceCNY = [dicCNY valueForKey:@"lp"];
            NSString *tmpLastCNYPrice = nowCNYPrice;
            nowCNYPrice = priceCNY;
            
            NSString *priceUSD = [dicUSD valueForKey:@"lp"];
            NSString *tmpLastUSDPrice = nowUSDPrice;
            nowUSDPrice = priceUSD;
            
            //Use this to update the UI instantaneously (otherwise, takes a little while)
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([target respondsToSelector:oneSelector])
                {
                    NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                             priceCNY, @"priceCNY",
                                             tmpLastCNYPrice, @"lastCNY",
                                             priceUSD, @"priceUSD",
                                             tmpLastUSDPrice, @"lastUSD",
                                             nil];
                    if(priceCNY.floatValue != 0)
                        [target performSelector:oneSelector withObject:infoDic];
                }
            });
        }
    }];
    [task resume];
}

//+(void)getCurrentPriceRunWithAciton:(id)target andHandler:(CLKComplicationTimelineEntry *)handler andSelector:(SEL)oneSelector{
//    int ranV = arc4random() % 1000;
//    NSString *urlPath = [NSString stringWithFormat:@"%@&%d",[GlobalObject currentURL],ranV];
//    NSURL *url = [NSURL URLWithString:urlPath];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    [request setHTTPMethod:@"GET"];
//    [request setTimeoutInterval:120];
//    [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
//    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"]; //告诉服务,返回的数据需要压缩
//    NSURLSession *session = [NSURLSession sharedSession];
//    
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (error == nil) {
//            NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            if([dataStr isEqualToString:lastDataStr])
//                NSLog(@"It's the same.");
//            else
//                NSLog(@"It's different.");
//            lastDataStr = dataStr;
//            
//            NSData* jsonData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
//            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
//            NSArray *dArr = [dic valueForKey:@"d"];
//            
//            NSDictionary *dicDetailCNY = [dArr objectAtIndex:0];
//            NSDictionary *dicCNY = [dicDetailCNY valueForKey:@"v"];
//            
//            
//            NSDictionary *dicDetailUSD = [dArr objectAtIndex:1];
//            NSDictionary *dicUSD = [dicDetailUSD valueForKey:@"v"];
//            
//            NSString *priceCNY = [dicCNY valueForKey:@"lp"];
//            nowCNYPrice = priceCNY;
//            
//            NSString *priceUSD = [dicUSD valueForKey:@"lp"];
//            nowUSDPrice = priceUSD;
//            
//            //Use this to update the UI instantaneously (otherwise, takes a little while)
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if ([target respondsToSelector:oneSelector])
//                {
//                    NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                             handler, @"handler",
//                                             priceCNY, @"priceCNY",
//                                             priceUSD, @"priceUSD",
//                                             nil];
//                    [target performSelector:oneSelector withObject:infoDic];
//                }
//            });
//        }
//    }];
//    [task resume];
//}

@end
