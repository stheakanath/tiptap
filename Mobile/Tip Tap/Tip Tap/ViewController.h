//
//  ViewController.h
//  Tip Tap
//
//  Created by Kuriakose Sony Theakanath on 1/7/16.
//  Copyright © 2016 Kuriakose Sony Theakanath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (retain, nonatomic) UILabel *intro;
@property (retain, nonatomic) UIImageView *instruction;


@end

