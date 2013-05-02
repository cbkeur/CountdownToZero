//
//  BNRPhotoVC.m
//  CountdownToZero
//
//  Created by Christian Keur on 5/1/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import "BNRPhotoVC.h"
#import "BNRMediaCell.h"
#import "BNRPhoto.h"
#import "BNRDataStore.h"

#define PHOTO_CELL @"PHOTO_CELL"

@interface BNRPhotoVC ()
{
    NSArray *_photoArray;
}

@end

@implementation BNRPhotoVC

#pragma mark - Initializers

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    
    if(self)
    {
        [self.navigationItem setTitle:@"Photos"];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self init];
}

#pragma mark - View Heirarchy

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self collectionView] registerClass: [BNRMediaCell class] forCellWithReuseIdentifier: PHOTO_CELL];
    
    // Load media
    [[BNRDataStore sharedStore] getPhotoListWithCompletion: ^(NSArray *photos, NSError *err) {
        if (photos) {
            _photoArray = [photos copy];
        }
    }];
}

#pragma mark - UICollectionView DataSource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"PhotoCount: %d", [_photoArray count]);
    return [_photoArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BNRMediaCell *cell = [[self collectionView] dequeueReusableCellWithReuseIdentifier: PHOTO_CELL forIndexPath: indexPath];
    
    if (!cell) {
        cell = [[BNRMediaCell alloc] init];
    }
    cell.photo = _photoArray[indexPath.row];
    return cell;
}

@end
