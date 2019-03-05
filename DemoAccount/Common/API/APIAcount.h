//
//  APIAcount.h
//  DemoAccount
//
//  Created by LongLy on 17/01/2019.
//  Copyright © 2019 LongLy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>

@interface APIAcount : NSObject
-(instancetype)init;
-(void)loginDropbox:(void(^)(BOOL result))complete;
-(void)logoutDropbox;
-(void)getlistfolderfileDropbox:(void(^)(NSArray *result))complete;
@end

