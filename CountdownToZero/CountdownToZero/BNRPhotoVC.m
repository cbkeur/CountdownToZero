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
#import "BNRPhotoViewerViewController.h"

#define PHOTO_CELL @"PHOTO_CELL"

@interface BNRPhotoVC () <BNRPhotoViewerDelegate>
{
    NSArray *_photoArray;
    BNRPhotoViewerViewController *_photoViewerViewController;
    BNRMediaCell *_hiddenCell;
}

- (void)handleTapGesture: (UITapGestureRecognizer *)tapGesture;

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
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                                 action: @selector(handleTapGesture:)];
    [[self collectionView] addGestureRecognizer: tapGesture];
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

#pragma mark - Gesture Recognizer Methods

- (void)handleTapGesture: (UITapGestureRecognizer *)tapGesture
{
    CGPoint tapPoint = [tapGesture locationInView: [self collectionView]];
    NSIndexPath *tapIndexPath = [[self collectionView] indexPathForItemAtPoint: tapPoint];
    
    if (tapIndexPath) {
        _hiddenCell = (BNRMediaCell *)[[self collectionView] cellForItemAtIndexPath: tapIndexPath];
        CGFloat navHeight = [[[self navigationController] navigationBar] frame].size.height;
       
        CGRect photoFrame = [_hiddenCell frame];
        photoFrame.origin.y += navHeight + 20.0f;
        _photoViewerViewController = [[BNRPhotoViewerViewController alloc] initWithPhoto: [_hiddenCell photo]
                                                                           andPhotoFrame: photoFrame];
        [_photoViewerViewController setDelegate: self];
        [_hiddenCell setHidden: YES];
        [[[self tabBarController] view] addSubview: [_photoViewerViewController view]];
    }
}

#pragma mark - BNRPhotoViewerViewController

- (void)photoViewerDidFinish:(BNRPhotoViewerViewController *)photoViewer
{
    [[_photoViewerViewController view] removeFromSuperview];
    _photoViewerViewController = nil;
    [_hiddenCell setHidden: NO];
    _hiddenCell = nil;
}


@end
