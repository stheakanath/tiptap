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
#import "PairedViewController.h"
#import <pop/pop.h>

@interface ExchangeViewController ()

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) PFGeoPoint *geo;
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
    [self.tipAmount setTextAlignment:NSTextAlignmentCenter];
    [self.tipAmount setText:@"$0"];
    [self.tipAmount setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:70.0f]];
    [self.tipAmount setTextColor: [UIColor whiteColor]];
    [self.view addSubview:self.tipAmount];
    
    self.chooseAmount = [[UILabel alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2 - 150, 80, 300, 100)];
    [self.chooseAmount setTextAlignment:NSTextAlignmentCenter];
    [self.chooseAmount setText:@"Choose Tip Amount"];
    [self.chooseAmount setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:33.0f]];
    [self.chooseAmount setTextColor: [UIColor whiteColor]];
    [self.view addSubview:self.chooseAmount];
    
    UIImage *image = [UIImage imageNamed:@"lol4.png"];
    //    UIImage *image = [UIImage animatedImageNamed:@"lol" duration:3.0f];
    self.instruction = [[UIImageView alloc] initWithFrame:CGRectMake(45, 510, image.size.width/15, image.size.height/15)];
    self.instruction.image = image;
    [self.view addSubview:self.instruction];
    
    self.tapToTip = [[UILabel alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2 - 105, 510, 300, 100)];
    [self.tapToTip setTextAlignment:UITextAlignmentCenter];
    [self.tapToTip setText:@"Shake to tip!"];
    [self.tapToTip setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:33.0f]];
    [self.tapToTip setTextColor: [UIColor whiteColor]];
    [self.view addSubview:self.tapToTip];
    
}

- (void) setGeo1:(PFGeoPoint*)geo1 {
    self.geo = geo1;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        // Time is number of seconds since epoch as a double
        self.user[@"isShaking"] = [NSNumber numberWithBool:YES];
        self.user[@"gps"] = self.geo;
        [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!succeeded) {
                NSLog(@"%@", error.description);
            }
        }];

        NSString *shakeTime = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
        [PFCloud callFunctionInBackground:@"attemptTransaction" withParameters:@{@"username" : self.user[@"username"], @"gps": self.geo, @"shake_time" : shakeTime, @"tip_amnt" : [_tipAmount.text substringFromIndex:1]} block:^(PFObject *returnedUser, NSError *error) {
            if (!error) {
                int value = [[_tipAmount.text substringFromIndex:1] intValue];
                [self executeTransfer:[NSNumber numberWithInt:value] medium:@"balance" fromAccountID:self.user[@"nessieId"] toAccountID:returnedUser[@"nessieId"] apiKey:@"3bdaaa3c82010b88c585c1e966c8d6f8"];
            }
        }];
        [self performSelector:@selector(endShake:) withObject:self afterDelay:30.0f];
    }
}

- (void)executeTransfer:(NSNumber*)amount medium:(NSString*)medium fromAccountID:(NSString*)fromAccountID toAccountID:(NSString*)toAccountID apiKey:(NSString*)apiKey {
    
    //Get Transaction Timestamp
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yy hh:mm:ss"];
    
    //Create JSON
    NSDictionary *dictionary = @{ @"medium" : medium, @"payee_id": toAccountID,
                                  @"amount": amount, @"transaction_date": [dateFormatter stringFromDate:[NSDate date]]};
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    
    //Create default configuration
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    //Create NSURL
    NSString * urlString = [NSString stringWithFormat:@"http://api.reimaginebanking.com/accounts/%@/transfers?key=%@", fromAccountID, apiKey];
    NSURL * url = [NSURL URLWithString:urlString];
    
    //Create url Request
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:jsonData];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //Create SessionDataTask
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSLog(@"Response:%@ %@\n", response, error);
            if(error == nil)
                                                           {
                                                               NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                               NSLog(@"Data = %@",text);
                                                               [self executeAnimationToSuccess];
                                                           }
                                                           
                                                       }];
    //Run Request
    [dataTask resume];
    
}

- (void) executeAnimationToSuccess {
    PairedViewController *v = [[PairedViewController alloc] init];
    CATransition* transition = [CATransition animation];
    
    transition.duration = 0.3;
    transition.type = kCATransitionFade;
    
    [[self navigationController].view.layer addAnimation:transition forKey:kCATransition];
    [[self navigationController] pushViewController:v animated:NO];
    
}

- (IBAction)endShake:(id)sender {
    self.user[@"isShaking"] = [NSNumber numberWithBool:NO];
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!succeeded)
            NSLog(@"%@", error.description);
    }];
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
    self.user = [PFUser currentUser];
    [self setNeedsStatusBarAppearanceUpdate];
    // Do any additional setup after loading the view.
    Circle *test2 = [[Circle alloc] init:[UIColor clearColor] withFrame:300];
    [test2 setFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2 - 150, [[UIScreen mainScreen] bounds].size.height/2-150, 300, 300)];

    
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
    int tip = [[_tipAmount.text substringFromIndex:1] intValue];
    if ((int) (ceil(slider.currentValue) / 10.) != tip) {
        CATransition *animation = [CATransition animation];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionFade;
        animation.duration = 0.3;
        [_tipAmount.layer addAnimation:animation forKey:@"kCATransitionFade"];
        _tipAmount.text = [NSString stringWithFormat:@"$%d", (int) (ceil(slider.currentValue) / 10.)];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end