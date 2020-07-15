//
//  ImageManager.h
//  DemoAccount
//
//  Created by Long Ly on 7/15/20.
//  Copyright © 2020 LongLy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photos/Photos.h"
#import "AlbumModel.h"
#import "ImageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImageManager : NSObject
+(id)sharedInstance;
-(void)getAllAlbum:(void(^)(NSArray *result))complete;
-(void)getImageForAllAlbum:(PHFetchResult<PHAsset *> *)listImage complete:(void(^)(NSArray<ImageModel *> *result))complete;
@end

NS_ASSUME_NONNULL_END
