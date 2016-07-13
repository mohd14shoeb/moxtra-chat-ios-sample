//
//  AppDelegate.m
//  MoxieChat
//
//  Created by Ken Yu on 12/7/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <ChatSDK/MXChatSDK.h>


#define str(x) @_str(x)
#define _str(x) #x

#define MOXTRASDK_TEST_APP_ClientID         vY86Cl-BouY     //please add your client ID and secret
#define MOXTRASDK_TEST_APP_ClientSecret     u46aYNSnQDc     //please add your client ID and secret


@interface AppDelegate ()
@property (strong, nonatomic) ViewController *viewController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Fill in the App Client ID and Client Secret Key received from the app registration step from Moxtra
    NSString *APP_CLIENT_ID = str(MOXTRASDK_TEST_APP_ClientID);
    NSString *APP_CLIENT_SECRET = str(MOXTRASDK_TEST_APP_ClientSecret);
    
    // Initialize Moxtra SDK
    // Set the serverType to productionServer when pointing your app to production environment
    [Moxtra clientWithApplicationClientID:APP_CLIENT_ID applicationClientSecret:APP_CLIENT_SECRET serverType: sandboxServer httpsDomain:nil wssDomain:nil];
    
    // Set root view controller
    self.viewController = [[ViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.window.rootViewController = navController;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
