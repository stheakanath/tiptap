//
//  AppDelegate.m
//  Tip Tap
//
//  Created by Kuriakose Sony Theakanath on 1/7/16.
//  Copyright © 2016 Kuriakose Sony Theakanath. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    ViewController *ini = [[ViewController alloc] init];
    UINavigationController *navControl = [[UINavigationController alloc] initWithRootViewController: ini];
    [self.window setRootViewController: navControl];
    [Parse setApplicationId:@"irQJP5wBT07xDDZvUFwZQh4oREygqeO4CFhIL7VH" clientKey:@"v8vM9udPaSg06B8fW4En8xntZz9Wse0SyC750VoE"];
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    //[[PFInstallation currentInstallation] setObject:[PFUser currentUser][@"username"] forKey:@"username"];
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *installation = [PFInstallation currentInstallation];
    [installation setDeviceTokenFromData:deviceToken];
    installation.channels = @[@"global"];
    [installation saveInBackground];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    application.applicationSupportsShakeToEdit = YES;
}


@end
