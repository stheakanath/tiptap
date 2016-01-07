//
//  ExchangeViewController.h
//  Tip Tap
//
//  Created by Kuriakose Sony Theakanath on 1/7/16.
//  Copyright © 2016 Kuriakose Sony Theakanath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

@interface ExchangeViewController : UIViewController <CLLocationManagerDelegate>

@property (retain, nonatomic)  UILabel *tipAmount;
@property (retain, nonatomic)  UILabel *chooseAmount;
@property (retain, nonatomic)  UILabel *tapToTip;

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

- (void) setGeo1:(PFGeoPoint*)geo1;

@end