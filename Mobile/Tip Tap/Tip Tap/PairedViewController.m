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
@property (nonatomic, retain) NSString *amountpaid;
@property (nonatomic, retain) UIButton *temp;
@property (nonatomic, retain) UIButton *user;
@property (nonatomic, retain) UIButton *reject;

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
    self.user = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.user setImage:[UIImage imageNamed:@"sony.png"] forState:UIControlStateNormal];
    //[self.user setImage:[UIImage imageNamed:@"user.jpg"] forState:UIControlStateNormal];
    
    self.user.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2 - (SIZE/2), [[UIScreen mainScreen] bounds].size.height/2 - (SIZE/2), SIZE, SIZE);
    self.user.clipsToBounds = YES;
    self.user.layer.cornerRadius = SIZE/2.0f;
    self.user.layer.borderColor=[UIColor whiteColor].CGColor;
    self.user.layer.borderWidth=10;
    [self.view addSubview:self.user];
    
    // accept button for person you've paired with
    self.accept = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.accept setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
    self.accept.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2 - (ICON_SIZE/2) + 130, [[UIScreen mainScreen] bounds].size.height/2 - (ICON_SIZE/2) + 155, ICON_SIZE, ICON_SIZE);
    self.accept.clipsToBounds = YES;
    self.accept.layer.cornerRadius = ICON_SIZE/2.0f;
    [self.view addSubview:self.accept];
    [self.accept addTarget:self action:@selector(accepted:) forControlEvents:UIControlEventTouchUpInside];

    // reject button for person you've paired with
    self.reject= [UIButton buttonWithType:UIButtonTypeCustom];
    [self.reject setImage:[UIImage imageNamed:@"x.png"] forState:UIControlStateNormal];
    self.reject.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2  - (ICON_SIZE/2) - 130, [[UIScreen mainScreen] bounds].size.height/2 - (ICON_SIZE/2)+ 155, ICON_SIZE, ICON_SIZE);
    self.reject.clipsToBounds = YES;
    self.reject.layer.cornerRadius = ICON_SIZE/2.0f;
    self.reject.layer.borderColor=[UIColor whiteColor].CGColor;
    self.reject.layer.borderWidth=4;
    [self.view addSubview:self.reject];
    [self.reject addTarget:self action:@selector(moveToNew:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) setOtherUser:(PFUser*)lol amountPaid:(NSString*)amt {
    self.otheruser = lol;
    self.amountpaid = amt;
}

- (IBAction)goBack:(id)sender {
    // move back to main page
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)accepted:(id)sender {
    // grab the layers
    [PFCloud callFunctionInBackground:@"notifyRecipient" withParameters:@{@"u_name" : self.otheruser[@"username"], @"amt": self.amountpaid} block:^(PFObject *returnedUser, NSError *error) {
        if (!error) {
            NSLog(@"Sucess!");
        }
    }];
    
    // hide other elements
    self.reject.hidden = true;
    self.pairmessage.hidden = true;
    self.user.hidden = true;
    
    // remove target so they don't get paid twice
    [self.accept removeTarget:self action:@selector(accepted:) forControlEvents:UIControlEventTouchDragInside];
    
    // change target so that we can switch to the next view
    [self.accept addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];

    // get the layer we want
    CALayer *layer = self.accept.layer;
    
    // remove all other animations
    [layer pop_removeAllAnimations];
    
    // declare animations we'll be using
    POPBasicAnimation *moveX = [POPBasicAnimation animation];
    POPBasicAnimation *moveY = [POPBasicAnimation animation];
    POPSpringAnimation *rotation = [POPSpringAnimation animation];
    POPBasicAnimation *grow = [POPBasicAnimation animation];
    
    // declare properties of those animations
    moveX.property = [POPAnimatableProperty propertyWithName: kPOPLayerPositionX];
    moveY.property = [POPAnimatableProperty propertyWithName: kPOPLayerPositionY];
    grow.property = [POPAnimatableProperty propertyWithName:kPOPLayerSize];
    rotation.property = [POPAnimatableProperty propertyWithName: kPOPLayerRotation];
    
    
    // declare what those animations do
    moveX.toValue= @(200);
    moveY.toValue= @(370);
    grow.toValue= [NSValue valueWithCGSize:CGSizeMake(300, 300)];
    rotation.toValue = @(M_PI_2 * 12);
    
    // name animations and delegate
    moveX.name=@"moveX";
    moveX.delegate=self;
    moveY.name=@"moveY";
    moveY.delegate=self;
    grow.name=@"grow";
    grow.delegate=self;
    rotation.name=@"rotation";
    rotation.delegate=self;
    
    
    // add animations to the layer
    [layer pop_addAnimation:grow forKey:@"grow"];
    [layer pop_addAnimation:rotation forKey:@"rotation"];
    [layer pop_addAnimation:moveX forKey:@"moveX"];
    [layer pop_addAnimation:moveY forKey:@"moveY"];
    
    // insert caption containing information about payment
    self.youpaid = [[UILabel alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2 - 75, 410, 150, 50)];
    [self.youpaid setTextAlignment:NSTextAlignmentCenter];
    [self.youpaid setText:@"You paid"];
    [self.youpaid setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:33.0f]];
    [self.youpaid setTextColor: [UIColor whiteColor]];
    [self.view addSubview:self.youpaid];

    //[self.navigationController popToRootViewControllerAnimated:YES];
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
