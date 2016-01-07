//
//  ExchangeViewController.m
//  Tip Tap
//
//  Created by Kuriakose Sony Theakanath on 1/7/16.
//  Copyright © 2016 Kuriakose Sony Theakanath. All rights reserved.
//

#import "ExchangeViewController.h"
#import "Circle.h"
#import "EFCircularSlider.h"
#import "BackgroundLayer.h"
#import <QuartzCore/QuartzCore.h>

@interface ExchangeViewController ()

@end

@implementation ExchangeViewController

- (void)setUpInterface {
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
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    circularSlider.lineWidth = 7;

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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end