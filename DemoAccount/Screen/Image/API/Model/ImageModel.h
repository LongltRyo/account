//
//  ImageModel.h
//  DemoAccount
//
//  Created by Long Ly on 7/15/20.
//  Copyright © 2020 LongLy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photos/Photos.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImageModel : NSObject
@property(nonatomic) NSString *imgID;
@property(nonatomic) PHAsset *asset;
@property(nonatomic) UIImage *image;
@end

NS_ASSUME_NONNULL_END
