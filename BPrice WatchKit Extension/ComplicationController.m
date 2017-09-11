//
//  ComplicationController.m
//  BPrice WatchKit Extension
//
//  Created by Alanc Liu on 4/30/16.
//  Copyright © 2016 Alanc Liu. All rights reserved.
//

#import "ComplicationController.h"

@implementation ComplicationController

#pragma mark - Timeline Configuration

-(void)requestedUpdateDidBegin{
    NSLog(@"requestedUpdateDidBegin");
    CLKComplicationServer *server = [CLKComplicationServer sharedInstance];
    for (CLKComplication *com in server.activeComplications) {
        [server reloadTimelineForComplication:com];
    }
    
}

-(void)requestedUpdateBudgetExhausted{
    NSLog(@"!!!!!!!!!!!!!!!!!!!!!!requestedUpdateBudgetExhausted!!!!!!!!!!!!!!!!!!!!");
}

- (void)getSupportedTimeTravelDirectionsForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTimeTravelDirections directions))handler {
    handler(CLKComplicationTimeTravelDirectionForward | CLKComplicationTimeTravelDirectionBackward);
}

- (void)getTimelineStartDateForComplication:(CLKComplication *)complication withHandler:(void(^)(NSDate * __nullable date))handler {
    handler(nil);
}

- (void)getTimelineEndDateForComplication:(CLKComplication *)complication withHandler:(void(^)(NSDate * __nullable date))handler {
    handler(nil);
}

- (void)getPrivacyBehaviorForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationPrivacyBehavior privacyBehavior))handler {
    handler(CLKComplicationPrivacyBehaviorShowOnLockScreen);
}

#pragma mark - Timeline Population

- (void)getCurrentTimelineEntryForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTimelineEntry * __nullable))handler {
    // Call the handler with the current timeline entry
    NSLog(@"getCurrentTimelineEntryForComplication");
    
    NSDictionary *globjPrice = [GlobalObject getNowPrice];
    if (globjPrice) {
        NSString *priceCNY = [globjPrice valueForKey:@"priceCNY"];
        NSString *priceUSD = [globjPrice valueForKey:@"priceUSD"];
        
        NSNumberFormatter *priceFormatter = [[NSNumberFormatter alloc] init];
        priceFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        
        NSString *cnyPrice = [priceFormatter stringFromNumber:[NSNumber numberWithFloat:priceCNY.floatValue]];
        NSString *usdPrice = [priceFormatter stringFromNumber:[NSNumber numberWithFloat:priceUSD.floatValue]];
        NSArray *listcny = [cnyPrice componentsSeparatedByString:@"."];
        NSArray *listusd = [usdPrice componentsSeparatedByString:@"."];
        NSString *disPartC = [NSString stringWithFormat:@"¥%@",[listcny objectAtIndex:0]];
        NSString *disPartU = [NSString stringWithFormat:@"$%@",[listusd objectAtIndex:0]];
        
        if (cnyPrice.floatValue != 0 && usdPrice.floatValue != 0) {
             handler([self getNowTimeLineObjectWithComplication:complication andCNYPrice:disPartC andUSDPrice:disPartU]);
        }
        else
            handler(nil);
    }
    else{
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
                
                NSData* jsonData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
                NSArray *dArr = [dic valueForKey:@"d"];
                
                NSDictionary *dicDetailCNY = [dArr objectAtIndex:0];
                NSDictionary *dicCNY = [dicDetailCNY valueForKey:@"v"];
                NSDictionary *dicDetailUSD = [dArr objectAtIndex:1];
                NSDictionary *dicUSD = [dicDetailUSD valueForKey:@"v"];
                
                NSString *priceCNY = [dicCNY valueForKey:@"lp"];
                NSString *priceUSD = [dicUSD valueForKey:@"lp"];
 
                NSNumberFormatter *priceFormatter = [[NSNumberFormatter alloc] init];
                priceFormatter.numberStyle = NSNumberFormatterDecimalStyle;
                
                NSString *cnyPrice = [priceFormatter stringFromNumber:[NSNumber numberWithFloat:priceCNY.floatValue]];
                NSString *usdPrice = [priceFormatter stringFromNumber:[NSNumber numberWithFloat:priceUSD.floatValue]];
                NSArray *listcny = [cnyPrice componentsSeparatedByString:@"."];
                NSArray *listusd = [usdPrice componentsSeparatedByString:@"."];
                NSString *disPartC = [NSString stringWithFormat:@"¥%@",[listcny objectAtIndex:0]];
                NSString *disPartU = [NSString stringWithFormat:@"$%@",[listusd objectAtIndex:0]];
                
                if (cnyPrice.floatValue != 0 && usdPrice.floatValue != 0) {
                    handler([self getNowTimeLineObjectWithComplication:complication andCNYPrice:disPartC andUSDPrice:disPartU]);
                }
                else
                    handler(nil);
            }
        }];
        [task resume];
    }
}

- (void)getTimelineEntriesForComplication:(CLKComplication *)complication beforeDate:(NSDate *)date limit:(NSUInteger)limit withHandler:(void(^)(NSArray<CLKComplicationTimelineEntry *> * __nullable entries))handler {
    // Call the handler with the timeline entries prior to the given date
    handler(nil);
}

- (void)getTimelineEntriesForComplication:(CLKComplication *)complication afterDate:(NSDate *)date limit:(NSUInteger)limit withHandler:(void(^)(NSArray<CLKComplicationTimelineEntry *> * __nullable entries))handler {
    // Call the handler with the timeline entries after to the given date
    handler(nil);
}


#pragma mark Update Scheduling

- (void)getNextRequestedUpdateDateWithHandler:(void(^)(NSDate * __nullable updateDate))handler {
    // Call the handler with the date when you would next like to be given the opportunity to update your complication content
    //    handler(nil);
    NSLog(@"##############################Nexe Data################################");
    handler([[NSDate alloc] initWithTimeIntervalSinceNow:5*60]);
}

#pragma mark - Placeholder Templates

- (void)getPlaceholderTemplateForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTemplate * __nullable complicationTemplate))handler {
    if(complication.family == CLKComplicationFamilyUtilitarianLarge){
        CLKComplicationTemplateUtilitarianLargeFlat *template =[[CLKComplicationTemplateUtilitarianLargeFlat alloc] init];
        template.textProvider = [CLKSimpleTextProvider textProviderWithText:@"BTC Price"];
        handler(template);
    }
    else if(complication.family == CLKComplicationFamilyUtilitarianSmall){
        CLKComplicationTemplateUtilitarianSmallFlat *template = [[CLKComplicationTemplateUtilitarianSmallFlat alloc] init];
        UIImage* image=[UIImage imageNamed:@"bitcoin.png"];
        CLKImageProvider *theImageProvider = [CLKImageProvider imageProviderWithOnePieceImage:image];
//        theImageProvider.tintColor = [UIColor whiteColor];
        template.imageProvider = theImageProvider;
        template.textProvider = [CLKSimpleTextProvider textProviderWithText:@"Price"];
        handler(template);
    }
    else if(complication.family == CLKComplicationFamilyModularSmall){
        CLKComplicationTemplateModularSmallStackImage *template = [[CLKComplicationTemplateModularSmallStackImage alloc] init];
        UIImage* image=[UIImage imageNamed:@"bitcoin.png"];
        CLKImageProvider *theImageProvider = [CLKImageProvider imageProviderWithOnePieceImage:image];
//        theImageProvider.tintColor = [UIColor whiteColor];
        template.line1ImageProvider = theImageProvider;
        template.line2TextProvider = [CLKSimpleTextProvider textProviderWithText:@"Price"];
        handler(template);
    }
    else
        handler(nil);
}

-(CLKComplicationTimelineEntry *)getNowTimeLineObjectWithComplication:(CLKComplication *)complication andCNYPrice:(NSString *)disPartC andUSDPrice:(NSString *)disPartU{
    NSString *displayPriceResult = @"Waiting";
    if(complication.family == CLKComplicationFamilyUtilitarianLarge){
        UIImage* image=[UIImage imageNamed:@"bitcoin.png"];
        
        if ([GlobalObject nowCNY])
            displayPriceResult = [NSString stringWithFormat:@"= CN %@  US %@",disPartC,disPartU];
        else
            displayPriceResult = [NSString stringWithFormat:@"= US %@  CN %@",disPartU,disPartC];
        
        CLKComplicationTemplateUtilitarianLargeFlat *template =[[CLKComplicationTemplateUtilitarianLargeFlat alloc] init];
        template.imageProvider = [CLKImageProvider imageProviderWithOnePieceImage:image];
        template.textProvider = [CLKSimpleTextProvider textProviderWithText:displayPriceResult];
        
        NSDate *tmpD = [NSDate date];
        CLKComplicationTimelineEntry *timelineEntry = [CLKComplicationTimelineEntry entryWithDate:tmpD complicationTemplate:template];
        return timelineEntry;
    }
    else if(complication.family == CLKComplicationFamilyUtilitarianSmall){
        UIImage* image=[UIImage imageNamed:@"bitcoin.png"];
        
        if ([GlobalObject nowCNY])
            displayPriceResult = disPartC;
        else
            displayPriceResult = disPartU;
        
        CLKComplicationTemplateUtilitarianSmallFlat *template =[[CLKComplicationTemplateUtilitarianSmallFlat alloc] init];
        template.imageProvider = [CLKImageProvider imageProviderWithOnePieceImage:image];
        template.textProvider = [CLKSimpleTextProvider textProviderWithText:displayPriceResult];
        NSDate *tmpD = [NSDate date];
        CLKComplicationTimelineEntry *timelineEntry = [CLKComplicationTimelineEntry entryWithDate:tmpD complicationTemplate:template];
        return timelineEntry;
    }
    else if(complication.family == CLKComplicationFamilyModularSmall){
        UIImage* image=[UIImage imageNamed:@"bitcoin.png"];
        
        if ([GlobalObject nowCNY])
            displayPriceResult = disPartC;
        else
            displayPriceResult = disPartU;
        
        CLKComplicationTemplateModularSmallStackImage *template =[[CLKComplicationTemplateModularSmallStackImage alloc] init];
        template.line1ImageProvider = [CLKImageProvider imageProviderWithOnePieceImage:image];
        template.line2TextProvider = [CLKSimpleTextProvider textProviderWithText:displayPriceResult];
        
        CLKComplicationTimelineEntry *timelineEntry = [CLKComplicationTimelineEntry entryWithDate:[NSDate date] complicationTemplate:template];
        return timelineEntry;
    }
    else
        return nil;
}


@end
