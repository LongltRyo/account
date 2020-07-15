//
//  AllAlbumViewController.m
//  DemoAccount
//
//  Created by Long Ly on 7/15/20.
//  Copyright © 2020 LongLy. All rights reserved.
//

#import "AllAlbumViewController.h"
#import "ImageManager.h"
#import "ImageMNGViewController.h"

@interface AllAlbumViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *albumList;
@end

@implementation AllAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellID"];

    [[ImageManager sharedInstance] getAllAlbum:^(NSArray * _Nonnull result) {
        self.albumList = result.mutableCopy;
        [self.tableView reloadData];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.albumList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
    }
    AlbumModel *model = [self.albumList objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ : %ld", model.title, model.listPHAsset.count];
    cell.imageView.image = [UIImage imageNamed:@""];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ImageMNGViewController *vc = [ImageMNGViewController new];
    vc.albumModel = [self.albumList objectAtIndex:indexPath.row];
    [self presentViewController:vc animated:true completion:nil];
}
@end
