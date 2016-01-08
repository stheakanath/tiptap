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

@end

@implementation PairedViewController

- (void)setUpInterface {
    // remove nav bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
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
    [temp setImage:[UIImage imageNamed:@"user.png"] forState:UIControlStateNormal];
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
    [accept addTarget:self action:@selector(moveToNew:) forControlEvents:UIControlEventTouchUpInside];

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

- (IBAction)moveToNew:(id)sender {
    ExchangeViewController *v = [[ExchangeViewController alloc] init];
    CATransition* transition = [CATransition animation];
    
    transition.duration = 0.3;
    transition.type = kCATransitionFade;
    
    [[self navigationController].view.layer addAnimation:transition forKey:kCATransition];
    [[self navigationController] pushViewController:v animated:NO];
    
    //[self.navigationController pushViewController:v animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpInterface];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
