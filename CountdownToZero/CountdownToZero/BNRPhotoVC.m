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

@end

@implementation BNRPhotoVC

#pragma mark - Initializers

- (id)init
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize: CGSizeMake(90.0f, 90.0f)];
    self = [super initWithCollectionViewLayout: flowLayout];
    
    if(self)
    {
        [self setTitle: @"Photos"];
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
    [[self view] setBackgroundColor:[UIColor carterBackgroundColor]];
    
    UIImageView *eagleHead = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"eaglehead"]];
    [eagleHead setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin];
    [eagleHead setAlpha:0.08];
    [[self view] insertSubview:eagleHead atIndex:0];
    [eagleHead setCenter:self.view.center];
    
    [[self collectionView] setBackgroundColor: [UIColor clearColor]];
    [[self collectionView] registerClass: [BNRMediaCell class] forCellWithReuseIdentifier: PHOTO_CELL];
    
    // Load media
    [[BNRDataStore sharedStore] getPhotoListWithCompletion: ^(NSArray *photos, NSError *err) {
        if (photos) {
            _photoArray = [photos copy];
            [[self collectionView] reloadData];
        }
    }];
}

#pragma mark - UICollectionView DataSource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
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

#pragma mark - UICollectionView Delegate Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _hiddenCell = (BNRMediaCell *)[[self collectionView] cellForItemAtIndexPath: indexPath];
    
    CGRect photoFrame = [[self collectionView] convertRect: [_hiddenCell frame] toView: nil];
    _photoViewerViewController = [[BNRPhotoViewerViewController alloc] initWithPhoto: [_hiddenCell photo]
                                                                       andPhotoFrame: photoFrame];
    [_photoViewerViewController setDelegate: self];
    [_hiddenCell setHidden: YES];
    [[[self tabBarController] view] addSubview: [_photoViewerViewController view]];
}

// TODO: Figure out how the menu thing works.
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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
