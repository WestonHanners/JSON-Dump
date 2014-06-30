//
//  JDAppDelegate.m
//  JSON Dump
//
//  Created by Weston Hanners on 6/30/14.
//  Copyright (c) 2014 Hanners Software. All rights reserved.
//

#import "JDAppDelegate.h"
#import "NSJSONSerialization+Dump.h"

@implementation JDAppDelegate

- (void)testJSONStuff {
    
        // Activate the category
    [NSJSONSerialization activate];
    
        // Download some JSON
    NSURL *url = [NSURL URLWithString:@"http://ip.jsontest.com/"];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    
    id ret = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    NSLog(@"%@", ret);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self.window makeKeyAndVisible];
    [self testJSONStuff];
    return YES;
}

- (UIWindow *)window {
    if (!_window) {
        CGRect bounds = [[UIScreen mainScreen] bounds];
        _window = [[UIWindow alloc] initWithFrame:bounds];
        [_window setBackgroundColor:[UIColor redColor]];
    }
    return _window;
}

@end
