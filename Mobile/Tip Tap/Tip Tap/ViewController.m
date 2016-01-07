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
#import "EFCircularSlider.h"
#import "ExchangeViewController.h"
#define ROUND_BUTTON_WIDTH_HEIGHT 300

@interface ViewController()

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSString *lat;
@property (nonatomic, retain) NSString *lon;
@property PFUser *user;

@property int requests;

@end


@implementation ViewController

-(void)roundButtonDidTap:(UIButton*)tappedButton{
    
    NSLog(@"roundButtonDidTap Method Called");
    
}

- (void)setUpInterface {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
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
    temp.layer.borderColor=[UIColor whiteColor].CGColor;
    temp.layer.borderWidth=.5f;
    [temp.layer addAnimation:rotate
                      forKey:@"myRotationAnimation"];
    [self.view addSubview:temp];
    [temp addTarget:self action:@selector(moveToNew:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (IBAction)moveToNew:(id)sender {
    ExchangeViewController *v = [[ExchangeViewController alloc] init];
    [self.navigationController pushViewController:v animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpInterface];
    self.requests = 0;
    //    self.user = [PFUser user];
    //    [self.user setUsername:@"Sony"];
    //    [self.user setPassword:@"fuckyouankit"];
    //    [self.user setEmail:@"ankit@sony.com"];
    //    [self.user signUp];
    //    user[@"username"] = @"Sony";
    //    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    //        if (succeeded) {
    //            // The object has been saved.
    //        } else {
    //            NSLog(@"%@", error.description);
    //        }
    //    }];
    
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:@"Sony"];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
        if (!error) {
            [userStats setObject:[NSNumber numberWithBool:YES] forKey:@"isOnline"];
            [userStats saveInBackground];
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
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
    //    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    //    [query getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
    //        if (!error) {
    //            [userStats setObject:[NSNumber numberWithBool:NO] forKey:@"isOnline"];
    //            [userStats saveInBackground];
    //        } else {
    //            NSLog(@"Error: %@", error);
    //        }
    //    }];
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
        [PFCloud callFunctionInBackground:@"attemptTransaction" withParameters:@{@"lat": self.lat, @"lng" : self.lon, @"shake_time" : shakeTime, @"tip_amnt" : @"2"} block:^(NSMutableArray *ratings, NSError *error) {
            if (!error) {
                NSLog(@"%@", ratings);
            }
            
        }];
        [self performSelector:@selector(endShake:) withObject:self afterDelay:30.0f];
    }
}

- (IBAction)endShake:(id)sender {
    //    [PFCloud callFunctionInBackground:@"setShake" withParameters:@{@"shake": @"false"} block:^(NSNumber *ratings, NSError *error) {
    //        if (!error) {
    //            // ratings is 4.5
    //        }
    //    }];
    self.user[@"isShaking"] = [NSNumber numberWithBool:NO];
    self.user[@"lat"] = self.lat;
    self.user[@"lng"] = self.lon;
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


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    NSLog(@"Error: %@", error.description);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *crnLoc = [locations lastObject];
    self.lat = [NSString stringWithFormat:@"%.8f", crnLoc.coordinate.latitude];
    self.lon = [NSString stringWithFormat:@"%.8f", crnLoc.coordinate.longitude];
    NSLog(@"Location has been updated.");
    if (self.requests < 3) {
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
    }
    self.requests+=1;
}

@end
