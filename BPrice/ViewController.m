//
//  ViewController.m
//  BPrice
//
//  Created by Alanc Liu on 4/30/16.
//  Copyright © 2016 Alanc Liu. All rights reserved.
//

#import "ViewController.h"
#import "MainView.h"
#import "CustomCollectionLayout.h"
#import "PictureCollectionView.h"

@interface ViewController ()

@property UIImageView* topPic;
@property UIImageView* bottomPic;
@property UILabel* lbTitle;
@property UIImageView* priceBackgroundPicture;
@property UIButton* btnSwitch;
@property UILabel* lbMainPrice;
@property UILabel* lbSMallPrice;
@property UILabel* lbUpdateTime;
@property UILabel* lbUpdateDate;
@property UILabel* lbInfo;
@property UILabel* lbVersion;
@property NSTimer* timer;

@end

@implementation ViewController

-(void)loadView{
    self.view = [[MainView alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //    UILabel *lbTittle = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 30)];
    //    [lbTittle setText:[NSString stringWithFormat:@"Current BPI" ]];
    //    lbTittle.textAlignment = NSTextAlignmentCenter;
    //    lbTittle.font = [UIFont systemFontOfSize:30];
    //    [self.view addSubview:lbTittle];
    //
    //    lbPrice = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, [UIScreen mainScreen].bounds.size.width, 40)];
    //    [lbPrice setText:[NSString stringWithFormat:@"Getting data........" ]];
    //    lbPrice.font = [UIFont systemFontOfSize:36];
    //    lbPrice.textAlignment = NSTextAlignmentCenter;
    //    [self.view addSubview:lbPrice];
    //
    //    lbLastTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, [UIScreen mainScreen].bounds.size.width, 20)];
    //    [lbLastTime setText:[NSString stringWithFormat:@"Getting data........" ]];
    //    lbLastTime.textAlignment = NSTextAlignmentCenter;
    //    [self.view addSubview:lbLastTime];
    //
    //    float screenWidth = [[UIScreen mainScreen] bounds].size.width;
    //    float screenHeight = [[UIScreen mainScreen] bounds].size.height;
    //    float padding = screenWidth/2 * 0.1;
    //    float locButtomY = screenHeight - screenWidth/2 - padding - 10;
    //    float locTopY = locButtomY - screenWidth/2 - padding;
    //
    //    UIImageView *imgV0 = [[UIImageView alloc] initWithFrame:CGRectMake(padding, locTopY, screenWidth/2 * 0.8, screenWidth/2)];
    //    UIImage* img0 = [UIImage imageNamed:@"main.PNG"];
    //    imgV0.image = img0;
    //    [self.view addSubview:imgV0];
    //
    //    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/2 * 0.8 + 3*padding, locTopY, screenWidth/2 * 0.8, screenWidth/2)];
    //    UIImage* imgMS = [UIImage imageNamed:@"mSmall.PNG"];
    //    imgV.image = imgMS;
    //    [self.view addSubview:imgV];
    //
    //    UIImageView *imgV1 = [[UIImageView alloc] initWithFrame:CGRectMake(padding, locButtomY, screenWidth/2 * 0.8, screenWidth/2)];
    //    UIImage* img1 = [UIImage imageNamed:@"large.PNG"];
    //    imgV1.image = img1;
    //    [self.view addSubview:imgV1];
    //
    //    UIImageView *imgV2 = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/2 * 0.8 + 3*padding, locButtomY, screenWidth/2 * 0.8, screenWidth/2)];
    //    UIImage* img2 = [UIImage imageNamed:@"small.PNG"];
    //    imgV2.image = img2;
    //    [self.view addSubview:imgV2];
    //
    //    float locLbinfoY = locTopY - padding - 50;
    //
    //    UILabel *lbInfo = [[UILabel alloc] initWithFrame:CGRectMake(0, locLbinfoY, [UIScreen mainScreen].bounds.size.width, 50)];
    //    [lbInfo setText:[NSString stringWithFormat:@"You can use complication on your Apple Watch like the picture, have fun." ]];
    //    lbInfo.textAlignment = NSTextAlignmentCenter;
    //    lbInfo.numberOfLines = 3;
    //    [self.view addSubview:lbInfo];
    //
    //    UILabel *Version = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-20, [UIScreen mainScreen].bounds.size.width, 20)];
    //    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //    NSString *versionStr = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    //    [Version setText:[NSString stringWithFormat:@"Version %@", versionStr]];
    //    Version.textAlignment = NSTextAlignmentCenter;
    //    [self.view addSubview:Version];
    //
    
    CGSize collectionSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 260);
    CustomCollectionLayout *flowLayout = [[CustomCollectionLayout alloc] init];
    [flowLayout initThisWith:collectionSize.width and:collectionSize.height];
    PictureCollectionView *pcv = [[PictureCollectionView alloc] initWithFrame:CGRectMake(0, 0, collectionSize.width,collectionSize.height) collectionViewLayout:flowLayout];
    [pcv InitThis];
    pcv.center = self.view.center;
    pcv.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:pcv];
    
    _lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 40)];
    _lbTitle.text = @"BTCC Price";
    _lbTitle.font = [UIFont systemFontOfSize:20];
    _lbTitle.textColor = [UIColor whiteColor];
    _lbTitle.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_lbTitle];
    
    float topHeight = 70;
    float PirceAreaTotalHeight = pcv.frame.origin.y - topHeight;
    float mainLabelHeight = 58;
    float smallLabelHeight = 33;
    float paddingHeight = 10;
    float contentTotalHeight = mainLabelHeight + smallLabelHeight + paddingHeight;
    
    float topLocY = (PirceAreaTotalHeight - contentTotalHeight)/2 + topHeight;
    
    _priceBackgroundPicture = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-258)/2, topLocY, 258, 58)];
    _priceBackgroundPicture.image = [UIImage imageNamed:@"According"];
    [self.view addSubview:_priceBackgroundPicture];
    
    _lbMainPrice = [[UILabel alloc] initWithFrame:CGRectMake(0, topLocY, self.view.frame.size.width, mainLabelHeight)];
    _lbMainPrice.font = [UIFont systemFontOfSize:25];
    _lbMainPrice.text = @"Loading......";
    _lbMainPrice.textColor = [UIColor whiteColor];
    _lbMainPrice.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_lbMainPrice];
    
    topLocY += _lbMainPrice.frame.size.height + paddingHeight;
    
    _lbSMallPrice = [[UILabel alloc] initWithFrame:CGRectMake(0, topLocY, self.view.frame.size.width, smallLabelHeight)];
    _lbSMallPrice.font = [UIFont systemFontOfSize:18];
    _lbSMallPrice.text = @"Loading......";
    _lbSMallPrice.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
    _lbSMallPrice.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_lbSMallPrice];
    
    _btnSwitch = [[UIButton alloc] initWithFrame:CGRectMake(_priceBackgroundPicture.frame.origin.x +_priceBackgroundPicture.frame.size.width-33, topLocY, 33, 33)];
    [_btnSwitch setImage:[UIImage imageNamed:@"button_switch"] forState:UIControlStateNormal];
    [_btnSwitch addTarget:self action:@selector(btnSwitchClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnSwitch];
    
    topLocY = pcv.frame.origin.y + pcv.frame.size.height + paddingHeight;
    
    _lbUpdateTime = [[UILabel alloc] initWithFrame:CGRectMake(0, topLocY, self.view.frame.size.width, 30)];
    _lbUpdateTime.text = @"Loading......";
    _lbUpdateTime.font = [UIFont systemFontOfSize:30];
    _lbUpdateTime.textColor = [UIColor whiteColor];
    _lbUpdateTime.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_lbUpdateTime];
    
    topLocY += _lbUpdateTime.frame.size.height;
    
    _lbUpdateDate = [[UILabel alloc] initWithFrame:CGRectMake(0, topLocY, self.view.frame.size.width, 20)];
    _lbUpdateDate.text = @"Loading......";
    _lbUpdateDate.font = [UIFont systemFontOfSize:20];
    _lbUpdateDate.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
    _lbUpdateDate.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_lbUpdateDate];
    
    topLocY = self.view.frame.size.height - 70;
    
    _lbInfo = [[UILabel alloc] initWithFrame:CGRectMake(0, topLocY, self.view.frame.size.width, 40)];
    _lbInfo.text = @"You can use complication on your Apple Watch like the picture, have fun.";
    [_lbInfo setNumberOfLines:2];
    _lbInfo.font = [UIFont systemFontOfSize:15];
    _lbInfo.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
    _lbInfo.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_lbInfo];
    
    topLocY = self.view.frame.size.height - 30;
    
    _lbVersion = [[UILabel alloc] initWithFrame:CGRectMake(0, topLocY, self.view.frame.size.width, 30)];
    NSString* versionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    _lbVersion.text = [NSString stringWithFormat:@"Version %@",versionStr];
    _lbVersion.font = [UIFont systemFontOfSize:15];
    _lbVersion.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
    _lbVersion.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_lbVersion];
    
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    [self timerFired];
    
    topLocY = (PirceAreaTotalHeight - contentTotalHeight)/2 + topHeight;
    
//    float mainWidth = [self widthForLabel:_lbMainPrice];
    _topPic = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-245)/2, topLocY + (mainLabelHeight-30)/2, 30, 30)];
    _topPic.image = [UIImage imageNamed:@"bitcoin_big"];
    _topPic.hidden = YES;
    [self.view addSubview:_topPic];
    
    topLocY += _lbMainPrice.frame.size.height + paddingHeight;
    
//    float smallWidth = [self widthForLabel:_lbSMallPrice];
    _bottomPic = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-150)/2, topLocY + (smallLabelHeight-15)/2, 15, 15)];
    _bottomPic.image = [UIImage imageNamed:@"bitcoin_big"];
    _bottomPic.hidden = YES;
    [self.view addSubview:_bottomPic];

    if([WCSession isSupported]){
        self.watchSession = [WCSession defaultSession];
        self.watchSession.delegate = self;
        [self.watchSession activateSession];
    }
}

-(void)timerFired{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    NSString *apiUrl = @"https://pro-data.btcc.com/data/udf/quotes?symbols=bpicny,bpiusd";
    
    NSString *urlPath = [NSString stringWithFormat:@"%@&%@",apiUrl,timeString];
    NSURL *url = [NSURL URLWithString:urlPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:20];
    [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"]; //告诉服务,返回的数据需要压缩
    NSURLSession *session = [NSURLSession sharedSession];
    NSLog(@"Send request.");
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"Get respone.");
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
            
            if(priceCNY.floatValue != 0 && priceUSD.floatValue != 0){
                NSString *cnyPrice = [priceFormatter stringFromNumber:[NSNumber numberWithFloat:priceCNY.floatValue]];
                NSString *usdPrice = [priceFormatter stringFromNumber:[NSNumber numberWithFloat:priceUSD.floatValue]];
                NSArray *listcny = [cnyPrice componentsSeparatedByString:@"."];
                NSArray *listusd = [usdPrice componentsSeparatedByString:@"."];
                NSString *disPartC = [NSString stringWithFormat:@"¥%@",[listcny objectAtIndex:0]];
                NSString *disPartU = [NSString stringWithFormat:@"$%@",[listusd objectAtIndex:0]];
                
                NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"hh:mm:ss"];
                NSString *time = [formatter stringFromDate:[NSDate date]];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSString *date = [formatter stringFromDate:[NSDate date]];
                
                //Use this to update the UI instantaneously (otherwise, takes a little while)
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([self nowCNY]) {
                        _lbMainPrice.text = [NSString stringWithFormat:@" = USD %@",disPartU];
                        _lbSMallPrice.text = [NSString stringWithFormat:@" = CNY %@",disPartC];
                    }
                    else{
                        _lbSMallPrice.text = [NSString stringWithFormat:@" = USD %@",disPartU];
                        _lbMainPrice.text = [NSString stringWithFormat:@" = CNY %@",disPartC];
                    }
                    [self adjustIconAndLabel];
                    _lbUpdateTime.text = time;
                    _lbUpdateDate.text = date;
                });
            }
        }
    }];
    [task resume];
}

-(void)btnSwitchClicked:(id)sender{
//    NSString* tmp = _lbSMallPrice.text;
//    _lbSMallPrice.text = _lbMainPrice.text;
//    _lbMainPrice.text = tmp;
//    [self setNowCNY:![self nowCNY]];
    
    if(self.watchSession){
        NSError *error = nil;
        if(![self.watchSession
             updateApplicationContext:
             @{@"message" : @"Hello world!" }
             error:&error]){
            NSLog(@"Updating the context failed: %@", error.localizedDescription);
        }
    }
    
    //    let complicationServer = CLKComplicationServer.sharedInstance()
    //    guard let activeComplications = complicationServer.activeComplications else { // watchOS 2.2
    //        return
    //    }
    //
    //    for complication in activeComplications {
    //        complicationServer.reloadTimelineForComplication(complication)
    //    }
}

- (WCSessionUserInfoTransfer *)transferCurrentComplicationUserInfo:(NSDictionary<NSString *,id> *)userInfo{
    NSLog(@"transferCurrentComplicationUserInfo");
    return nil;
}

-(void)adjustIconAndLabel{
    float mainImageLength = 30;
    float smallImageLength = 15;
    
    float mainLocY = _lbMainPrice.frame.origin.y;
    float mainHeight = _lbMainPrice.frame.size.height;
    [_lbMainPrice sizeToFit];
    float mainWidth = _lbMainPrice.frame.size.width;
    float topGroupLocX = ([UIScreen mainScreen].bounds.size.width - mainWidth - mainImageLength)/2;
    _topPic.frame = CGRectMake(topGroupLocX, mainLocY + (mainHeight - mainImageLength)/2, mainImageLength, mainImageLength);
    _topPic.hidden = NO;
    _lbMainPrice.frame = CGRectMake(topGroupLocX+mainImageLength, mainLocY, mainWidth, mainHeight);
    
//    _lbMainPrice.backgroundColor = [UIColor redColor];
//    _topPic.backgroundColor = [UIColor blueColor];
    
    float smallLocY = _lbSMallPrice.frame.origin.y;
    float smallHeight = _lbSMallPrice.frame.size.height;
    [_lbSMallPrice sizeToFit];
    float smallWidth = _lbSMallPrice.frame.size.width;
    float bottomGroupLocX = ([UIScreen mainScreen].bounds.size.width - smallWidth - smallImageLength)/2;
    _bottomPic.frame = CGRectMake(bottomGroupLocX, smallLocY + (smallHeight - smallImageLength)/2, smallImageLength, smallImageLength);
    _bottomPic.hidden = NO;
    _lbSMallPrice.frame = CGRectMake(bottomGroupLocX+smallImageLength, smallLocY, smallWidth, smallHeight);
}

-(BOOL)nowCNY{
    bool flag = [[NSUserDefaults standardUserDefaults] boolForKey:@"isNowCNY"];
    return flag;
}

-(void)setNowCNY:(BOOL)flag{
    [[NSUserDefaults standardUserDefaults] setBool:flag forKey:@"isNowCNY"];
    [self adjustIconAndLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
