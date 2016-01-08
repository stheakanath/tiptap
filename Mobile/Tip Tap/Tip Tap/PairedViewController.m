//
//  PairedViewController.m
//  Tip Tap
//
//  Created by Gabriela Carmen Merz on 1/7/16.
//  Copyright © 2016 Kuriakose Sony Theakanath. All rights reserved.
//
#import "ViewController.h"
#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "EFCircularSlider.h"
#import "ExchangeViewController.h"
#import "BackgroundLayer.h"
#import <pop/POP.h>
#import "PairedViewController.h"
#import "BackgroundLayer.h"
#define SIZE 300
#define ICON_SIZE 80

@interface PairedViewController ()

@property (nonatomic, retain) PFUser *otheruser;
@property (nonatomic, retain) NSString* amountpaid;

@end

@implementation PairedViewController

- (void)setUpInterface {
    // remove nav bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.topItem.title = @"";
    
    // background color
    [self.view setBackgroundColor:UIColorFromRGB(0xf5f5f5)];
    CAGradientLayer *bgLayer = [BackgroundLayer greyGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    
    // pairing text (letting you know you've been tipped / are tipping someone)
    self.pairmessage = [[UILabel alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2 - 150, 80, 300, 100)];
    [self.pairmessage setTextAlignment:UITextAlignmentCenter];
    [self.pairmessage setText:@"Paired with..."];
    [self.pairmessage setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:33.0f]];
    [self.pairmessage setTextColor: [UIColor whiteColor]];
    [self.view addSubview:self.pairmessage];
    
    // image of who your'e tipping / is tipping you
    UIButton *temp = [UIButton buttonWithType:UIButtonTypeCustom];
    [temp setImage:[UIImage imageNamed:@"sony.png"] forState:UIControlStateNormal];
    temp.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2 - (SIZE/2), [[UIScreen mainScreen] bounds].size.height/2 - (SIZE/2), SIZE, SIZE);
    temp.clipsToBounds = YES;
    temp.layer.cornerRadius = SIZE/2.0f;
    temp.layer.borderColor=[UIColor whiteColor].CGColor;
    temp.layer.borderWidth=10;
    [self.view addSubview:temp];
    
    // accept button for person you've paired with
    UIButton *accept = [UIButton buttonWithType:UIButtonTypeCustom];
    [accept setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
    accept.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2 - (ICON_SIZE/2) + 130, [[UIScreen mainScreen] bounds].size.height/2 - (ICON_SIZE/2) + 155, ICON_SIZE, ICON_SIZE);
    accept.clipsToBounds = YES;
    accept.layer.cornerRadius = ICON_SIZE/2.0f;
    accept.layer.borderColor=[UIColor whiteColor].CGColor;
    accept.layer.borderWidth=4;
    [self.view addSubview:accept];
    [accept addTarget:self action:@selector(accepted:) forControlEvents:UIControlEventTouchUpInside];

    // reject button for person you've paired with
    UIButton *reject = [UIButton buttonWithType:UIButtonTypeCustom];
    [reject setImage:[UIImage imageNamed:@"x.png"] forState:UIControlStateNormal];
    reject.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2  - (ICON_SIZE/2) - 130, [[UIScreen mainScreen] bounds].size.height/2 - (ICON_SIZE/2)+ 155, ICON_SIZE, ICON_SIZE);
    reject.clipsToBounds = YES;
        reject.layer.cornerRadius = ICON_SIZE/2.0f;
    reject.layer.borderColor=[UIColor whiteColor].CGColor;
    reject.layer.borderWidth=4;
    [self.view addSubview:reject];
    [reject addTarget:self action:@selector(moveToNew:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) setOtherUser:(PFUser*)lol amountPaid:(NSString*)amt {
    self.otheruser = lol;
    self.amountpaid = amt;
}

- (IBAction)accepted:(id)sender {
    [PFCloud callFunctionInBackground:@"notifyRecipient" withParameters:@{@"u_name" : self.otheruser[@"username"], @"amt": self.amountpaid} block:^(PFObject *returnedUser, NSError *error) {
        if (!error) {
            NSLog(@"HELLOOOOO");
        }
    }];

    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)moveToNew:(id)sender {
    ExchangeViewController *v = [[ExchangeViewController alloc] init];
    CATransition* transition = [CATransition animation];
    
    transition.duration = 0.3;
    transition.type = kCATransitionFade;
    [[self navigationController].view.layer addAnimation:transition forKey:kCATransition];
    [[self navigationController] pushViewController:v animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpInterface];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
