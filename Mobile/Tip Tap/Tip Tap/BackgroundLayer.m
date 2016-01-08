//
//  BackgroundLayer.m
//  Tip Tap
//
//  Created by Jeffrey Chang on 1/7/16.
//  Copyright © 2016 Kuriakose Sony Theakanath. All rights reserved.
//

#import "BackgroundLayer.h"

@implementation BackgroundLayer

//Metallic grey gradient background
+ (CAGradientLayer*) greyGradient {
    
    UIColor *colorOne = UIColorFromRGB(0x238415);
    UIColor *colorTwo = UIColorFromRGB(0x238415);
    UIColor *colorThree = UIColorFromRGB(0x87eb78);
    UIColor *colorFour = UIColorFromRGB(0x87eb78);
    
    NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, colorThree.CGColor, colorFour.CGColor, nil];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:0.02];
    NSNumber *stopThree     = [NSNumber numberWithFloat:0.99];
    NSNumber *stopFour = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, stopThree, stopFour, nil];
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
    
}

//Metallic grey gradient background
+ (CAGradientLayer*) doubleGradient {
    
    //0x87eb78
//    UIColor *colorOne = UIColorFromRGB(0x238415);
//    UIColor *colorTwo = UIColorFromRGB(0x238415);
//    UIColor *colorThree = UIColorFromRGB(0x9eed91);
//    UIColor *colorFour = UIColorFromRGB(0x238415);
//    UIColor *colorFive = UIColorFromRGB(0x238415);
    
    UIColor *colorOne = UIColorFromRGB(0x238415);
    UIColor *colorTwo = UIColorFromRGB(0xb1f1a7);
    UIColor *colorThree = UIColorFromRGB(0x238415);
    
    NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, colorThree.CGColor, nil];
    
//    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
//    NSNumber *stopTwo = [NSNumber numberWithFloat:0.10];
//    NSNumber *stopThree = [NSNumber numberWithFloat:0.5];
//    NSNumber *stopFour     = [NSNumber numberWithFloat:0.90];
//    NSNumber *stopFive = [NSNumber numberWithFloat:1.0];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:0.5];
    NSNumber *stopThree = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, stopThree, nil];
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
    
}

@end
