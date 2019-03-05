//
//  AppDelegate.h
//  DemoAccount
//
//  Created by LongLy on 03/01/2019.
//  Copyright © 2019 LongLy. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
@import GoogleSignIn;

@interface AppDelegate : UIResponder <UIApplicationDelegate, GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

