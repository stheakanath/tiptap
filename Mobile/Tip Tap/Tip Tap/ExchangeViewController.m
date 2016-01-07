//
//  ExchangeViewController.m
//  Tip Tap
//
//  Created by Kuriakose Sony Theakanath on 1/7/16.
//  Copyright © 2016 Kuriakose Sony Theakanath. All rights reserved.
//

#import "ExchangeViewController.h"
#import "Circle.h"
#import <Parse/Parse.h>
#import "EFCircularSlider.h"
#import "BackgroundLayer.h"
#import <QuartzCore/QuartzCore.h>
#import <pop/pop.h>

@interface ExchangeViewController ()

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSString *lat;
@property (nonatomic, retain) NSString *lon;
@property PFUser *user;

@end

@implementation ExchangeViewController

- (void)setUpInterface {
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.topItem.title = @"";
    
    [self.view setBackgroundColor:UIColorFromRGB(0xf5f5f5)];

    CAGradientLayer *bgLayer = [BackgroundLayer greyGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    
    self.tipAmount = [[UILabel alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2 - 150, [[UIScreen mainScreen] bounds].size.height/2 - 150, 300, 300)];
    [self.tipAmount setTextAlignment:UITextAlignmentCenter];
    [self.tipAmount setText:@"$0"];
    [self.tipAmount setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:70.0f]];
    [self.tipAmount setTextColor: [UIColor whiteColor]];
    [self.view addSubview:self.tipAmount];
    
    self.chooseAmount = [[UILabel alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2 - 150, 80, 300, 100)];
    [self.chooseAmount setTextAlignment:UITextAlignmentCenter];
    [self.chooseAmount setText:@"Choose Tip Amount"];
    [self.chooseAmount setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:33.0f]];
    [self.chooseAmount setTextColor: [UIColor whiteColor]];
    [self.view addSubview:self.chooseAmount];
    
    self.tapToTip = [[UILabel alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2 - 150, 500, 300, 100)];
    [self.tapToTip setTextAlignment:UITextAlignmentCenter];
    [self.tapToTip setText:@"Tap to tip"];
    [self.tapToTip setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:33.0f]];
    [self.tapToTip setTextColor: [UIColor whiteColor]];
    [self.view addSubview:self.tapToTip];
    
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        // Time is number of seconds since epoch as a double
        self.user[@"isShaking"] = [NSNumber numberWithBool:YES];
        self.user[@"lat"] = self.lat;
        self.user[@"lng"] = self.lon;
        [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                // The object has been saved.
            } else {
                NSLog(@"%@", error.description);
            }
        }];
        
        
        NSString *shakeTime = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
        [PFCloud callFunctionInBackground:@"attemptTransaction" withParameters:@{@"lat": self.lat, @"lng" : self.lon, @"shake_time" : shakeTime, @"tip_amnt" : @"2"} block:^(NSMutableArray *ratings, NSError *error) {
            if (!error) {
                NSLog(@"%@", ratings);
            }
            
        }];
        [self performSelector:@selector(endShake:) withObject:self afterDelay:30.0f];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        CATransition *transition = [CATransition animation];
        [transition setDuration:0.75];
        [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [transition setType:@"oglFade"];
        [transition setSubtype:kCATransitionFromLeft];
        [transition setDelegate:self];
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
    }
    
   // [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    double width = [[UIScreen mainScreen] bounds].size.width;
    double height = [[UIScreen mainScreen] bounds].size.height;
    
    [self setNeedsStatusBarAppearanceUpdate];
    // Do any additional setup after loading the view.
    Circle *test2 = [[Circle alloc] init:[UIColor clearColor] withFrame:300];
    [test2 setFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2 - 150, [[UIScreen mainScreen] bounds].size.height/2-150, 300, 300)];
    
//    CAGradientLayer *gradientMask2 = [CAGradientLayer layer];
//    gradientMask2.frame = test2.bounds;
//    gradientMask2.colors = @[(id)[UIColor clearColor].CGColor,
//                            (id)UIColorFromRGB(0x195f0f).CGColor];
//    test2.layer.mask = gradientMask2;
    
    [self.view addSubview:test2];
    
    CGRect sliderFrame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2 - 150, [[UIScreen mainScreen] bounds].size.height/2-150, 300, 300);
    EFCircularSlider* circularSlider = [[EFCircularSlider alloc] initWithFrame:sliderFrame];
    
    circularSlider.filledColor = [UIColor whiteColor];
    //circularSlider.filledColor = UIColorFromRGB(0x195f0f);
    circularSlider.unfilledColor = UIColorFromRGB(0x238415);
    //[UIColor whiteColor];
    circularSlider.lineWidth = 10;

    [circularSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:circularSlider];
    [circularSlider setCurrentValue:10.0f];
    
    [self setUpInterface];
    
}

-(void)valueChanged:(EFCircularSlider*)slider {
    NSLog(@"slider value %d\n", (int) (ceil(slider.currentValue) / 10.));
    int tip = [[_tipAmount.text substringFromIndex:1] intValue];
    NSLog(@"tipAmount %d\n", tip);
    
    if ((int) (ceil(slider.currentValue) / 10.) != tip) {
        NSLog(@"yo\n");
        CATransition *animation = [CATransition animation];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionFade;
        animation.duration = 0.3;
        [_tipAmount.layer addAnimation:animation forKey:@"kCATransitionFade"];
        _tipAmount.text = [NSString stringWithFormat:@"$%d", (int) (ceil(slider.currentValue) / 10.)];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end