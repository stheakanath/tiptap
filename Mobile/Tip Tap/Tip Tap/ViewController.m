//
//  ViewController.m
//  Tip Tap
//
//  Created by Kuriakose Sony Theakanath on 1/7/16.
//  Copyright © 2016 Kuriakose Sony Theakanath. All rights reserved.
//

#import "ViewController.h"
#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "EFCircularSlider.h"
#import "ExchangeViewController.h"
#import "BackgroundLayer.h"
#define ROUND_BUTTON_WIDTH_HEIGHT 300

@interface ViewController()

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSString *lat;
@property (nonatomic, retain) NSString *lon;
@property (nonatomic, retain) PFGeoPoint *geo;
@property PFUser *user;

@property int requests;

@end


@implementation ViewController

-(void)roundButtonDidTap:(UIButton*)tappedButton{
    
    NSLog(@"roundButtonDidTap Method Called");
    
}

- (void)setUpInterface {
    
    // remove navbar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // background color
    [self.view setBackgroundColor:UIColorFromRGB(0xf5f5f5)];
    
    CAGradientLayer *bgLayer = [BackgroundLayer greyGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    //Circular Rotation
    CABasicAnimation *rotate =
    [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate.byValue = @(M_PI*2); // Change to - angle for counter clockwise rotation
    rotate.duration = 3.0;
    rotate.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    //Temp button
    UIButton *temp = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [temp setImage:[UIImage imageNamed:@"tiptap_icon.png"] forState:UIControlStateNormal];
    [temp addTarget:self action:@selector(roundButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    
    //width and height should be same value
    temp.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2 - (ROUND_BUTTON_WIDTH_HEIGHT/2), [[UIScreen mainScreen] bounds].size.height/2 - (ROUND_BUTTON_WIDTH_HEIGHT/2), ROUND_BUTTON_WIDTH_HEIGHT, ROUND_BUTTON_WIDTH_HEIGHT);
    
    //Clip/Clear the other pieces whichever outside the rounded corner
    temp.clipsToBounds = YES;
    
    //half of the width
    temp.layer.cornerRadius = ROUND_BUTTON_WIDTH_HEIGHT/2.0f;
    [temp.layer addAnimation:rotate
                      forKey:@"myRotationAnimation"];
    [self.view addSubview:temp];
    [temp addTarget:self action:@selector(moveToNew:) forControlEvents:UIControlEventTouchUpInside];
    self.intro = [[UILabel alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2 - 150, 500, 300, 100)];
    [self.intro setTextAlignment:UITextAlignmentCenter];
    [self.intro setText:@"Tap to Tip"];
    [self.intro setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:33.0f]];
    [self.intro setTextColor: [UIColor whiteColor]];
    [self.view addSubview:self.intro];
    
}

- (IBAction)moveToNew:(id)sender {
    ExchangeViewController *v = [[ExchangeViewController alloc] init];
    CATransition* transition = [CATransition animation];
    
    transition.duration = 0.3;
    transition.type = kCATransitionFade;
    
    [[self navigationController].view.layer addAnimation:transition forKey:kCATransition];
    [[self navigationController] pushViewController:v animated:NO];
    
    //[self.navigationController pushViewController:v animated:YES];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpInterface];
    self.requests = 0;
    if (![PFUser currentUser]) {
        PFLogInViewController *logInController = [[PFLogInViewController alloc] init];
        logInController.fields = PFLogInFieldsUsernameAndPassword
        | PFLogInFieldsLogInButton
        | PFLogInFieldsSignUpButton
        | PFLogInFieldsPasswordForgotten;
        logInController.delegate = self;
        [self presentViewController:logInController animated:YES completion:nil];
    }
    
    self.user = [PFUser currentUser];
    [self.user setObject:[NSNumber numberWithBool:YES] forKey:@"isOnline"];
    [self.user saveInBackground];
    
}

- (void)logInViewController:(PFLogInViewController *)controller
               didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    //Getting Location
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];

}

// Need to shake as a whip to sense
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
        [PFCloud callFunctionInBackground:@"attemptTransaction" withParameters:@{@"gps": self.geo, @"lat": self.lat, @"lng" : self.lon, @"shake_time" : shakeTime, @"tip_amnt" : @"2"} block:^(NSMutableArray *ratings, NSError *error) {
            if (!error) {
                NSLog(@"%@", ratings);
            }
            
        }];
        [self performSelector:@selector(endShake:) withObject:self afterDelay:30.0f];
    }
}

- (IBAction)endShake:(id)sender {

    self.user[@"isShaking"] = [NSNumber numberWithBool:NO];

    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
        } else {
            NSLog(@"%@", error.description);
        }
    }];
}

#pragma mark - Location Manager Stuff

- (void)requestWhenInUseAuthorization {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
        NSString *title;
        title = (status == kCLAuthorizationStatusDenied) ? @"Location services are off" : @"Background location is not enabled";
        NSString *message = @"To use background location you must turn on 'Always' in the Location Services";
        UIAlertView *alertViews = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Settings", nil];
        [alertViews show];
    } else if (status == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    NSLog(@"Error: %@", error.description);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *crnLoc = [locations lastObject];
    self.geo = [PFGeoPoint geoPointWithLocation:crnLoc];
    self.lat = [NSString stringWithFormat:@"%.8f", crnLoc.coordinate.latitude];
    self.lon = [NSString stringWithFormat:@"%.8f", crnLoc.coordinate.longitude];
    NSLog(@"Location has been updated.");
    if (self.requests < 3) {
        self.user[@"isShaking"] = [NSNumber numberWithBool:YES];
        self.user[@"gps"] = self.geo;
        [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!succeeded) {
                NSLog(@"%@", error.description);
            }
        }];
    }
    self.requests += 1;
}

@end
