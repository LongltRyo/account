//
//  ACHomeViewController.m
//  DemoAccount
//
//  Created by LongLy on 17/01/2019.
//  Copyright © 2019 LongLy. All rights reserved.
//

#import "ACHomeViewController.h"
#import "APIAcount.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "RecoderViewController.h"
@import Firebase;
@import GoogleSignIn;

@interface ACHomeViewController ()<GIDSignInUIDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lbstatus;
@property (weak, nonatomic) IBOutlet UIButton *btnLoginDropbox;
@property(weak, nonatomic) IBOutlet UIButton *signInButton;
@property(nonatomic)FIRUser *user;
@property (nonatomic)APIAcount *api;
@end

@implementation ACHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.api = [[APIAcount alloc] init];
    [GIDSignIn sharedInstance].uiDelegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusAcountDropbox:) name:@"GoogleAcount" object:nil];
    [self setupUI];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidLoad];
    [self setupUI];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)statusAcountDropbox:(NSNotification *) notification{
    NSDictionary *userInfo = notification.userInfo;
    self.user = [userInfo objectForKey:@"GoogleKey"];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self setupUI];
}

-(void)setupUI{
    if ([DBClientsManager authorizedClient] || [DBClientsManager authorizedTeamClient]) {
        [self.btnLoginDropbox setTitle:@"LogOutDropbox" forState:UIControlStateNormal];
    } else {
        [self.btnLoginDropbox setTitle:@"LoginDropbox" forState:UIControlStateNormal];
    }
    if (self.user) {
        [self.signInButton setTitle:@"LogoutGoogle" forState:UIControlStateNormal];
    } else {
        [self.signInButton setTitle:@"LoginGoogle" forState:UIControlStateNormal];
    }
}
//Dropbox
-(void)CheckLogin{
    if ([DBClientsManager authorizedClient] || [DBClientsManager authorizedTeamClient]) {
    }
}
- (IBAction)loginDropbox:(id)sender {
   if ([DBClientsManager authorizedClient] || [DBClientsManager authorizedTeamClient]) {
       [self.api logoutDropbox];
       [self setupUI];
   } else {
       [self.api loginDropbox:^(BOOL result) {
           [self setupUI];
       }];
   }
}
- (IBAction)loadFileDropbox:(id)sender {
    if ([DBClientsManager authorizedClient] || [DBClientsManager authorizedTeamClient]) {
        [self.api getlistfolderfileDropbox:^(NSArray *result) {
            for (int i = 0; i < result.count; i++) {
                NSLog(@"LONGLT: %@\n",result[i]);
            }
        }];
    } else {
        [self AlertError];
    }
}
-(void)AlertError{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Waring" message:@"Login truoc" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:ok];
    [alert showViewController:self sender:nil];
}

//Google
- (IBAction)loginGoogle:(id)sender {
    if (self.user) {
        NSError *signOutError;
        BOOL status = [[FIRAuth auth] signOut:&signOutError];
        if (!status) {
            NSLog(@"Error signing out: %@", signOutError);
            return;
        }
        [[GIDSignIn sharedInstance] signOut];
        self.user = nil;
    } else {
        [[GIDSignIn sharedInstance] signIn];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [self setupUI];
}
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations on signed in user here.
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    NSLog(@"adfadsf");
}

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    NSLog(@"%@",error.description);
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController {
    //present view controller
    [self presentViewController:viewController animated:YES completion:^{
        
    }];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
    //dismiss view controller
    [viewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)showViewRecoder:(id)sender {
    RecoderViewController *vc = [[RecoderViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
