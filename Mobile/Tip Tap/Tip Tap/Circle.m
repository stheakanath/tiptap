//
//  Circle.m
//  Tip Tap
//
//  Created by Kuriakose Sony Theakanath on 1/7/16.
//  Copyright © 2016 Kuriakose Sony Theakanath. All rights reserved.
//

#import "Circle.h"

@implementation Circle

- (id) init: (UIColor*) color withFrame: (int) num {
    self = [super initWithFrame:CGRectMake(0,0,num,num)];
    self.layer.cornerRadius = num/2;
    self.backgroundColor = color;
    return self;
    
}

@end
