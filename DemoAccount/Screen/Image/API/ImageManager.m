//
//  ImageManager.m
//  DemoAccount
//
//  Created by Long Ly on 7/15/20.
//  Copyright © 2020 LongLy. All rights reserved.
//

#import "ImageManager.h"

@interface ImageManager()

@property (nonatomic) PHCachingImageManager *imageManager;

@end

@implementation ImageManager

static ImageManager *sharedInstance = nil;

+(id)sharedInstance
{
    @synchronized (self) {
        if(sharedInstance == nil){
            sharedInstance = [ImageManager new];
        }
    }
    return sharedInstance;
}


-(void)getAllAlbum:(void(^)(NSArray *result))complete{
    
    PHFetchOptions *fetchOptions = [PHFetchOptions new];
    fetchOptions.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary | PHAssetSourceTypeCloudShared | PHAssetSourceTypeiTunesSynced;
//    fetchOptions.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"mediaType = %ld", (long)PHAssetMediaTypeImage]];
    
    //    opt.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:true]];
    PHFetchResult<PHAssetCollection *> *albums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:fetchOptions];
    PHFetchResult<PHAssetCollection *> *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:fetchOptions];
    NSMutableArray *list = [NSMutableArray new];
    [albums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHFetchOptions *opt1 = [PHFetchOptions new];
        opt1.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:true]];
        opt1.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"mediaType = %ld", (long)PHAssetMediaTypeImage]];
        PHFetchResult<PHAsset *> *imgs = [PHAsset fetchAssetsInAssetCollection:obj options:opt1];
        AlbumModel *model = [[AlbumModel alloc] init];
        model.idAlbum = obj.localIdentifier;
        model.title = obj.localizedTitle;
        model.phCollection = obj;
        model.listPHAsset = imgs;
        if(imgs.count > 0 && ![list containsObject:model]){
            [list addObject:model];
        }
    }];
    [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHFetchOptions *opt1 = [PHFetchOptions new];
        opt1.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:true]];
        opt1.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"mediaType = %ld", (long)PHAssetMediaTypeImage]];
        PHFetchResult<PHAsset *> *imgs = [PHAsset fetchAssetsInAssetCollection:obj options:opt1];
        AlbumModel *model = [[AlbumModel alloc] init];
        model.idAlbum = obj.localIdentifier;
        model.title = obj.localizedTitle;
        model.phCollection = obj;
        model.listPHAsset = imgs;
        if(imgs.count > 0 && ![list containsObject:model]){
            [list addObject:model];
        }
    }];
    NSLog(@"====> %lu", (unsigned long)list.count);
    complete(list);
}

-(void)getImageForAllAlbum:(PHFetchResult<PHAsset *> *)listImage complete:(void(^)(NSArray<ImageModel *> *result))complete{
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    CGSize size = CGSizeMake(300, 300);
    NSMutableArray *imgs = [NSMutableArray new];
    [listImage enumerateObjectsUsingBlock:^(PHAsset *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[PHCachingImageManager defaultManager] requestImageForAsset:obj targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            ImageModel *imageModel = [[ImageModel alloc] init];
            imageModel.imgID = obj.localIdentifier;
            imageModel.asset = obj;
            imageModel.image = result;
            [imgs addObject:imageModel];
            if (idx == listImage.count -1) {
            }
        }];
    }];
    complete(imgs);
}
@end
