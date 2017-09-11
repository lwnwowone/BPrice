//
//  GlobalObject.h
//  PriceAss
//
//  Created by Alanc Liu on 4/26/16.
//  Copyright © 2016 Alanc Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InterfaceController.h"

@interface GlobalObject : NSObject

+(void)getCurrentPriceRunWithAciton:(id)target andSelector:(SEL)oneSelector;

+(NSDictionary *)getNowPrice;

+(void)refreshComplications;

+(BOOL)nowCNY;
+(void)setNowCNY:(BOOL)flag;

+(NSString *)currentURL;

@end
