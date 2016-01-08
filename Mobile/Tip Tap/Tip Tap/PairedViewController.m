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
    //[temp setImage:[UIImage imageNamed:@"user.jpg"] forState:UIControlStateNormal];
    
    temp.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2 - (SIZE/2), [[UIScreen mainScreen] bounds].size.height/2 - (SIZE/2), SIZE, SIZE);
    temp.clipsToBounds = YES;
    temp.layer.cornerRadius = SIZE/2.0f;
    temp.layer.borderColor=[UIColor whiteColor].CGColor;
    temp.layer.borderWidth=10;
    [self.view addSubview:temp];
    
    // accept button for person you've paired with
    self.accept = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.accept setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
    self.accept.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2 - (ICON_SIZE/2) + 130, [[UIScreen mainScreen] bounds].size.height/2 - (ICON_SIZE/2) + 155, ICON_SIZE, ICON_SIZE);
    self.accept.clipsToBounds = YES;
    self.accept.layer.cornerRadius = ICON_SIZE/2.0f;
    self.accept.layer.borderColor=[UIColor whiteColor].CGColor;
    self.accept.layer.borderWidth=4;
    [self.view addSubview:self.accept];
    [self.accept addTarget:self action:@selector(accepted:) forControlEvents:UIControlEventTouchUpInside];

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

- (IBAction)goBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)accepted:(id)sender {
    // grab the layers
    [PFCloud callFunctionInBackground:@"notifyRecipient" withParameters:@{@"u_name" : self.otheruser[@"username"], @"amt": self.amountpaid} block:^(PFObject *returnedUser, NSError *error) {
        if (!error) {
            NSLog(@"Sucess!");
        }
    }];
    [self.accept removeTarget:self action:@selector(accepted:) forControlEvents:UIControlEventTouchDragInside];
    [self.accept addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];

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
    moveX.toValue= @(160);
    moveY.toValue= @(260);
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
