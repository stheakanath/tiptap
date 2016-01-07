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

@interface ViewController()

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSString *lat;
@property (nonatomic, retain) NSString *lon;
@end

@implementation ViewController

- (void)setUpInterface {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    [query whereKey:@"name" equalTo:@"Sony"];
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
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
        if (!error) {
            [userStats setObject:[NSNumber numberWithBool:NO] forKey:@"isOnline"];
            [userStats saveInBackground];
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
}

// Need to shake as a whip to sense
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        // Time is number of seconds since epoch as a double
        NSString *shakeTime = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
        [PFCloud callFunctionInBackground:@"attemptTransaction" withParameters:@{@"lat": self.lat, @"lng" : self.lon, @"shake_time" : shakeTime, @"tip_amnt" : @"2"} block:^(NSNumber *ratings, NSError *error) {
            if (!error) {
                // ratings is 4.5
            }
        }];
    }
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
}

@end
