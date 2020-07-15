//
//  ImageMNGViewController.m
//  DemoAccount
//
//  Created by Long Ly on 7/7/20.
//  Copyright © 2020 LongLy. All rights reserved.
//

#import "ImageMNGViewController.h"
#import "Photos/Photos.h"
#import "ImageManager.h"
#import "ImageModel.h"

@interface ImageMNGViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSArray<ImageModel *> *listImage;
@property (nonatomic) CGSize targetSize;
@property (nonatomic) CGFloat kCellSpacing;
@property (nonatomic) CGFloat kColumnCnt;

@end

@implementation ImageMNGViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.kCellSpacing = 2;
    self.kColumnCnt = 3;
    CGFloat imgWidth = (UIScreen.mainScreen.bounds.size.width - (_kCellSpacing * _kColumnCnt) -1)/ _kColumnCnt;
    CGSize targetSize = CGSizeMake(imgWidth, imgWidth);
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = targetSize;
    layout.minimumInteritemSpacing = _kCellSpacing;
    layout.minimumLineSpacing = _kCellSpacing;
    _collectionView.collectionViewLayout = layout;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [[ImageManager sharedInstance] getImageForAllAlbum:self.albumModel.listPHAsset complete:^(NSArray * _Nonnull result) {
        self.listImage = result.mutableCopy;
        [self.collectionView reloadData];
    }];
    
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listImage.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    UIImageView *imView = [[UIImageView alloc] initWithFrame:cell.bounds];
    [cell addSubview:imView];
    if (cell == nil) {
        NSLog(@"CELL NIL");
    }
    ImageModel *model = [self.listImage objectAtIndex:indexPath.row];
    imView.image = model.image;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat imgWidth = (UIScreen.mainScreen.bounds.size.width - (_kCellSpacing * _kColumnCnt) -1)/ _kColumnCnt;
    return CGSizeMake(imgWidth, imgWidth);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageModel *model = [_listImage objectAtIndex:indexPath.row];
    NSLog(@"===> %ld: %@", (long)indexPath.row, model.imgID);
}

@end
