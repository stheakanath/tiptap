//
//  PairedViewController.h
//  Tip Tap
//
//  Created by Gabriela Carmen Merz on 1/7/16.
//  Copyright © 2016 Kuriakose Sony Theakanath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PairedViewController : UIViewController

@property (retain, nonatomic)  UILabel *pairmessage;
@property (retain, nonatomic)  UILabel *youpaid;

- (void) setOtherUser:(PFUser*)lol amountPaid:(NSString*)amt;
@property (nonatomic, retain) UIButton *accept; 
@end
