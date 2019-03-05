//
//  APIAcount.m
//  DemoAccount
//
//  Created by LongLy on 17/01/2019.
//  Copyright © 2019 LongLy. All rights reserved.
//

#import "APIAcount.h"

@interface APIAcount()
@property(nonatomic)DBUserClient *client;
@property(nonatomic) UIActivityIndicatorView *indicatorView;
@property(nonatomic)NSMutableArray *result;
@end

@implementation APIAcount

-(instancetype)init{
    self = [super init];
    if (self) {
        self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [[[self class] topMostController].view addSubview:self.indicatorView];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(statusAcountDropbox:)
                                                     name:@"DropboxAcount"
                                                   object:nil];
    }
    return self;
}
-(void)statusAcountDropbox:(NSNotification *) notification{
    NSDictionary *userInfo = notification.userInfo;
    DBOAuthResult *authResult = [userInfo objectForKey:@"DropboxKey"];
    if (authResult != nil) {
        if ([authResult isSuccess]) {
            NSLog(@"Success! User is logged into Dropbox.");
            self.client = [DBClientsManager authorizedClient];
        } else if ([authResult isCancel]) {
            NSLog(@"Authorization flow was manually canceled by user!");
        } else if ([authResult isError]) {
            NSLog(@"Error: %@", authResult);
        }
    }
}
-(void)loginDropbox:(void(^)(BOOL result))complete {
    [DBClientsManager authorizeFromController:[UIApplication sharedApplication]
                                   controller:[[self class] topMostController]
                                      openURL:^(NSURL *url) {
                                          [[UIApplication sharedApplication] openURL:url];
                                          complete(YES);
                                      }];
}
-(void)logoutDropbox{
    [DBClientsManager unlinkAndResetClients];
}

+ (UIViewController*)topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}
- (void)listFolderContinueWithClientcursor:(NSString *)cursor :(void(^)(NSArray *result))complete{
    NSMutableArray *newArray = [NSMutableArray new];
    [[self.client.filesRoutes listFolder:cursor]
     setResponseBlock:^(DBFILESListFolderResult *response, DBFILESListFolderError *routeError, DBRequestError *networkError) {
         if (response) {
             NSArray<DBFILESMetadata *> *entries = response.entries;
             for (DBFILESMetadata *entry in entries) {
                 if ([entry isKindOfClass:[DBFILESFileMetadata class]]) {
                     DBFILESFileMetadata *fileMetadata = (DBFILESFileMetadata *)entry;
                     NSLog(@"File dataF1: %@\n", fileMetadata);
//                     if ([self isMediaType:fileMetadata.name]) {
                         [newArray addObject:fileMetadata];
//                     }
                 } else if ([entry isKindOfClass:[DBFILESFolderMetadata class]]) {
                     if ([[entry.name pathExtension] isEqualToString:@""] == NO) {
                         // is a file package / bundle
                         DBFILESFileMetadata *fileMetadata = (DBFILESFileMetadata *)entry;
                         NSLog(@"File dataF2: %@\n", fileMetadata);
                         [newArray addObject:fileMetadata];
                     } else {
                         DBFILESFolderMetadata *folderMetadata = (DBFILESFolderMetadata *)entry;
                         // is a folder
                         [self listFolderContinueWithClientcursor:folderMetadata.pathLower :^(NSArray *result) {
//                             NSLog(@"Folder dataF1: %@\n", result);
                             [newArray addObject:result];
//                             NSLog(@"LONGLT: mang %lu\n", (unsigned long)result.count);
                         }];
                     }
                 } else if ([entry isKindOfClass:[DBFILESDeletedMetadata class]]) {
                     DBFILESDeletedMetadata *deletedMetadata = (DBFILESDeletedMetadata *)entry;
                     NSLog(@"Deleted data: %@\n", deletedMetadata);
                 }
                 [self mainTheard:^{
                     complete(newArray);
                 }];
             }
         } else {
             [self routeError:routeError andnetworkError:networkError];
         }
     }];
}

-(void)getlistfolderfileDropbox:(void(^)(NSArray *result))complete{
    if(!self.result){
        self.result = [NSMutableArray new];
    }
    NSString *searchPath = @"";
    if(self.client == nil){
        self.client = [DBClientsManager authorizedClient];
    }
    [self listFolderContinueWithClientcursor:searchPath :^(NSArray *result) {
        complete(result);
    }];
    // list folder metadata contents (folder will be root "/" Dropbox folder if app has permission
    // "Full Dropbox" or "/Apps/<APP_NAME>/" if app has permission "App Folder").
}
- (void)mainTheard:(void (^)(void))mainTheard {
    dispatch_async(dispatch_get_main_queue(), ^{
        mainTheard();
    });
}

-(void)routeError:(DBFILESListFolderError *)routeError andnetworkError:(DBRequestError *)networkError{
    NSString *title = @"";
    NSString *message = @"";
    if (routeError) {
        // Route-specific request error
        title = @"Route-specific error";
        if ([routeError isPath]) {
            message = [NSString stringWithFormat:@"Invalid path: %@", routeError.path];
        }
    } else {
        // Generic request error
        title = @"Generic request error";
        if ([networkError isInternalServerError]) {
            DBRequestInternalServerError *internalServerError = [networkError asInternalServerError];
            message = [NSString stringWithFormat:@"%@", internalServerError];
        } else if ([networkError isBadInputError]) {
            DBRequestBadInputError *badInputError = [networkError asBadInputError];
            message = [NSString stringWithFormat:@"%@", badInputError];
        } else if ([networkError isAuthError]) {
            DBRequestAuthError *authError = [networkError asAuthError];
            message = [NSString stringWithFormat:@"%@", authError];
        } else if ([networkError isRateLimitError]) {
            DBRequestRateLimitError *rateLimitError = [networkError asRateLimitError];
            message = [NSString stringWithFormat:@"%@", rateLimitError];
        } else if ([networkError isHttpError]) {
            DBRequestHttpError *genericHttpError = [networkError asHttpError];
            message = [NSString stringWithFormat:@"%@", genericHttpError];
        } else if ([networkError isClientError]) {
            DBRequestClientError *genericLocalError = [networkError asClientError];
            message = [NSString stringWithFormat:@"%@", genericLocalError];
        }
    }
    
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:title
                                        message:message
                                 preferredStyle:(UIAlertControllerStyle)UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:(UIAlertActionStyle)UIAlertActionStyleCancel
                                                      handler:nil]];
    [[[self class] topMostController] presentViewController:alertController animated:YES completion:nil];
    
    [self setFinished];
}

- (BOOL)isMediaType:(NSString *)itemName {
    NSRange range = [itemName rangeOfString:@"\\.mp3|\\.mp4|\\.avi|\\.flv|\\.m4a|\\.m4r|\\.m4v|\\.mkv|\\.mov|\\.mpeg|\\.mts|\\.mpg|\\.oga|\\.ogg|\\.scm|\\.wmv|\\.wmv|\\.mpg|\\.vob|\\.wma" options:NSRegularExpressionSearch];
    return range.location != NSNotFound;
}

- (void)displayPhotos:(NSArray<DBFILESMetadata *> *)folderEntries {
    NSMutableArray<NSString *> *mediaPaths = [NSMutableArray new];
    for (DBFILESMetadata *entry in folderEntries) {
        
        NSString *itemName = entry.name;
        if ([self isMediaType:itemName]) {
            [mediaPaths addObject:entry.pathDisplay];
        }
    }
    
    if ([mediaPaths count] > 0) {
        NSString *imagePathToDownload = mediaPaths[arc4random_uniform((int)[mediaPaths count] - 1)];
//        [self downloadImage:imagePathToDownload];
    } else {
        NSString *title = @"No media found";
        NSString *message = @"There are currently no valid media files in the specified search path in your Dropbox. "
        @"Please add some media and try again.";
        UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:title
                                            message:message
                                     preferredStyle:(UIAlertControllerStyle)UIAlertControllerStyleAlert];
        [alertController
         addAction:[UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyle)UIAlertActionStyleCancel handler:nil]];
        [[[self class] topMostController] presentViewController:alertController animated:YES completion:nil];
        [self setFinished];
    }
}


- (void)setStarted {
    [_indicatorView startAnimating];
    _indicatorView.hidden = NO;
}

- (void)setFinished {
    [_indicatorView stopAnimating];
    _indicatorView.hidden = YES;
}

@end
