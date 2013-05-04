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
#import "BNRSectionHeader.h"

#define PHOTO_CELL @"PHOTO_CELL"
#define SECTION_HEADER @"SECTION_HEADER"

@interface BNRPhotoVC () <BNRPhotoViewerDelegate, UICollectionViewDelegateFlowLayout>
{
    NSArray *_photoArray;
    NSArray *_infographicArray;
    BNRPhotoViewerViewController *_photoViewerViewController;
    BNRMediaCell *_hiddenCell;
    
    BOOL _reflow;
}

- (void)reflowLayout: (UITapGestureRecognizer *)sender;

@end

@implementation BNRPhotoVC

#pragma mark - Initializers

- (id)init
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize: CGSizeMake(90.0f, 90.0f)];
    [flowLayout setSectionInset: UIEdgeInsetsMake(20, 0, 20, 0)];
    [flowLayout setHeaderReferenceSize: CGSizeMake(100, 30)];
    
    self = [super initWithCollectionViewLayout: flowLayout];
    
    if(self)
    {
        [self setTitle: @"Images"];
        _reflow = NO;
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
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                                 action: @selector(reflowLayout:)];
    [tapGesture setNumberOfTapsRequired: 3];
    [tapGesture setNumberOfTouchesRequired: 2];
    
    [[self collectionView] addGestureRecognizer: tapGesture];
    
    [[self collectionView] setBackgroundColor: [UIColor clearColor]];
    [[self collectionView] registerClass: [BNRMediaCell class] forCellWithReuseIdentifier: PHOTO_CELL];
    [[self collectionView] registerClass: [BNRSectionHeader class]
              forSupplementaryViewOfKind: UICollectionElementKindSectionHeader
                     withReuseIdentifier: SECTION_HEADER];
    
    
    __block int count = 0;
    void (^updateBlock)(void) = ^{
        count--;
        if(count == 0)
            [[self collectionView] reloadData];
    };
    
    count++;
    [[BNRDataStore sharedStore] getPhotoListWithCompletion: ^(NSArray *photos, NSError *err) {
        if (photos)
            _photoArray = [photos copy];
        
        updateBlock();
    }];
    
    count++;
    [[BNRDataStore sharedStore] getInfographicListWithCompletion: ^(NSArray *infographics, NSError *err) {
        if (infographics)
            _infographicArray = [infographics copy];
        
        updateBlock();
    }];
}

- (void)reflowLayout:(UITapGestureRecognizer *)sender
{
    NSLog(@"Reflowing");
    _reflow = !_reflow;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize: CGSizeMake(90.0f, 90.0f)];
    [flowLayout setSectionInset: UIEdgeInsetsMake(20, 0, 20, 0)];
    [flowLayout setHeaderReferenceSize: CGSizeMake(100, 30)];
    [[self collectionView] setCollectionViewLayout: flowLayout animated: YES];
    //[[self collectionView] reloadData];
}

#pragma mark - UICollectionView DataSource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0 && _infographicArray)
        return [_infographicArray count];
    
    return  [_photoArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BNRMediaCell *cell = [[self collectionView] dequeueReusableCellWithReuseIdentifier: PHOTO_CELL forIndexPath: indexPath];
    
    if (!cell) {
        cell = [[BNRMediaCell alloc] init];
    }
    if (indexPath.section == 0 && _infographicArray)
        cell.photo = _infographicArray[indexPath.row];
    else
        cell.photo = _photoArray[indexPath.row];
    
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    int numberOfSections = 0;
    if ([_photoArray count] > 0)
        numberOfSections++;
    if ([_infographicArray count] > 0)
        numberOfSections++;
    
    return numberOfSections;
}

- (UICollectionReusableView *)collectionView: (UICollectionView *)collectionView
           viewForSupplementaryElementOfKind: (NSString *)kind
                                 atIndexPath: (NSIndexPath *)indexPath
{
    BNRSectionHeader *sectionHeader = [[self collectionView] dequeueReusableSupplementaryViewOfKind: kind
                                                                                withReuseIdentifier:SECTION_HEADER
                                                                                       forIndexPath: indexPath];
    
    if ([indexPath section] == 0 && _infographicArray) {
        [[sectionHeader sectionNameLabel] setText: @"Infographics"];
    }
    else {
        [[sectionHeader sectionNameLabel] setText: @"Photos"];
    }
    return sectionHeader;
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
    
//    [[[self tabBarController] view] addSubview: [_photoViewerViewController view]];
    
    [_photoViewerViewController.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [_photoViewerViewController.view setFrame:self.view.window.bounds];
    [self.view.window addSubview:_photoViewerViewController.view];
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

#pragma mark - UICollectionViewDelegateFlowLayout Methods

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets insets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    return insets;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_reflow) {
        if (indexPath.row % 3 == 2)
            return CGSizeMake(300.0f, 300.0f);
        return CGSizeMake(145.0f, 145.0f);
    }
    
    return CGSizeMake(90.0f, 90.0f);
}

@end
