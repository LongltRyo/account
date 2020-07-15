//
//  AlbumModel.h
//  DemoAccount
//
//  Created by Long Ly on 7/15/20.
//  Copyright © 2020 LongLy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photos/Photos.h"
#import "ImageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlbumModel : NSObject
@property(nonatomic) NSString *idAlbum;
@property(nonatomic) PHAssetCollection *phCollection;
@property(nonatomic) NSString *title;
@property(nonatomic) NSArray<ImageModel *> *listImageModels;
@property(nonatomic) PHFetchResult<PHAsset *> *listPHAsset;

@end

NS_ASSUME_NONNULL_END
