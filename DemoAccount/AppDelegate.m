//
//  AppDelegate.m
//  DemoAccount
//
//  Created by LongLy on 03/01/2019.
//  Copyright © 2019 LongLy. All rights reserved.
//

#import "AppDelegate.h"
#import "ACHomeViewController.h"
#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>

@interface AppDelegate ()

@end
#define weakify(_var_) typeof(_var_) __weak _var_ ## _weak_ = _var_

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [DBClientsManager setupWithAppKey:@"hzu1et2tgi0qcgg"];
    [FIRApp configure];
    [GIDSignIn sharedInstance].clientID = [FIRApp defaultApp].options.clientID;
    [GIDSignIn sharedInstance].delegate = self;

    ACHomeViewController *vc = [[ACHomeViewController alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setRootViewController:vc];
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(nonnull UIApplication *)application
            openURL:(nonnull NSURL *)url
            options:(nonnull NSDictionary<NSString *, id> *)options {
    NSString *host = url.scheme;
    NSString *registeredUrlToHandle = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"][0][@"CFBundleURLSchemes"][0];
    if ([host isEqualToString:registeredUrlToHandle]) {
        DBOAuthResult *authResult = [DBClientsManager handleRedirectURL:url];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:authResult forKey:@"DropboxKey"];
        [[NSNotificationCenter defaultCenter] postNotificationName:
         @"DropboxAcount" object:nil userInfo:userInfo];
    } else {
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                          annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    }
    return NO;
}
- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // ...
    if (error == nil) {
        GIDAuthentication *authentication = user.authentication;
        FIRAuthCredential *credential =
        [FIRGoogleAuthProvider credentialWithIDToken:authentication.idToken
                                         accessToken:authentication.accessToken];
        
        [[FIRAuth auth] signInAndRetrieveDataWithCredential:credential
                                                 completion:^(FIRAuthDataResult * _Nullable authResult,
                                                              NSError * _Nullable error) {
                                                     if (error) {
                                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"GoogleAcount" object:nil];
                                                         return;
                                                     }
                                                     // User successfully signed in. Get user data from the FIRUser object
                                                     if (authResult == nil) { return; }
                                                     FIRUser *user = authResult.user;
                                                     NSDictionary *userInfo = [NSDictionary dictionaryWithObject:user forKey:@"GoogleKey"];
                                                     [[NSNotificationCenter defaultCenter] postNotificationName:
                                                      @"GoogleAcount" object:nil userInfo:userInfo];
                                                 }];
        
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GoogleAcount" object:nil];
    }
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
