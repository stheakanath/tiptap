//
//  AppDelegate.m
//  Tip Tap
//
//  Created by Kuriakose Sony Theakanath on 1/7/16.
//  Copyright © 2016 Kuriakose Sony Theakanath. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Parse setApplicationId:@"irQJP5wBT07xDDZvUFwZQh4oREygqeO4CFhIL7VH" clientKey:@"v8vM9udPaSg06B8fW4En8xntZz9Wse0SyC750VoE"];
    return YES;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    application.applicationSupportsShakeToEdit = YES;
}


@end
