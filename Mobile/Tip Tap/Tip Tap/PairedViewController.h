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

- (void) setOtherUser:(PFUser*)lol amountPaid:(NSString*)amt;

@end
