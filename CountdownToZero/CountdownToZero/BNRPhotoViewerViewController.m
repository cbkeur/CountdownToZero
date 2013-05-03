//
//  BNRPhotoViewerViewController.m
//  CountdownToZero
//
//  Created by Thomas Ward on 5/2/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import "BNRPhotoViewerViewController.h"
#import "BNRPhoto.h"
#import "BNRDataStore.h"

@interface BNRPhotoViewerViewController () <UIScrollViewDelegate>
{
    IBOutlet UIView *_backgroundView;
    IBOutlet UIView *_imageCellView;
    IBOutlet UIImageView *_photoImageView;
    IBOutlet UITextView *_captionTextView;
    IBOutlet UIScrollView *_scrollView;
    IBOutlet UIActivityIndicatorView *_activityIndicatorView;
    
    BNRPhoto *_photo;
    CGRect _startFrame;
}

- (void)handleTapGesture: (UITapGestureRecognizer *)tapGesture;

@end

@implementation BNRPhotoViewerViewController

- (id)initWithPhoto: (BNRPhoto *)photo andPhotoFrame: (CGRect)frame
{
    self = [super initWithNibName: nil bundle: nil];
    if (self) {
        _photo = photo;
        _startFrame = frame;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithPhoto: nil andPhotoFrame: CGRectZero];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                                           action: @selector(handleTapGesture:)];
    [tapGestureRecognizer setNumberOfTapsRequired: 1];
    [tapGestureRecognizer setDelaysTouchesEnded: YES];
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                                                 action: @selector(handleTapGesture:)];
    [doubleTapGestureRecognizer setNumberOfTapsRequired: 2];
    [[self view] addGestureRecognizer: tapGestureRecognizer];
    [[self view] addGestureRecognizer: doubleTapGestureRecognizer];
    
    [_imageCellView setFrame: _startFrame];
    [_imageCellView setBackgroundColor: [UIColor colorWithRed: 149.0f / 255.0f green: 40.0f / 255.0f blue: 0.0 alpha: 1.0]];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame: [_imageCellView bounds]];
    [_activityIndicatorView setHidesWhenStopped: YES];
    [_activityIndicatorView setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [_imageCellView addSubview: _activityIndicatorView];
    
    if ([_photo photo])
        [_photoImageView setImage: [_photo photo]];
    else {
        [_activityIndicatorView startAnimating];
        UIActivityIndicatorView * __weak activityIndicatorView = _activityIndicatorView;
        UIImageView * __weak imageView = _photoImageView;
        BNRPhoto * __weak photo = _photo;
        [[BNRDataStore sharedStore] getPhoto: photo WithCompletion: ^(NSData *data, NSError *err) {
            if (data) {
                [activityIndicatorView stopAnimating];
                UIImage *image = [UIImage imageWithData: data];
                if (image) {
                    [imageView setImage: image];
                    [photo setPhoto: image];
                }
            }
        }];
    }


    [_photoImageView setContentMode: UIViewContentModeScaleAspectFit];
    [_captionTextView setText: [_photo caption]];
    [_captionTextView setHidden: YES];
    
    CGPoint centerPoint = [[self view] center];
    CGSize viewSize = [[self view] frame].size;
    CGRect newFrame;
    
    if (viewSize.height > viewSize.width) {
        newFrame.size.width = viewSize.width - 10.0;
        newFrame.size.height = newFrame.size.width;
        newFrame.origin.x = 5.0f;
        newFrame.origin.y = centerPoint.y - (newFrame.size.height / 2.0f);
    }
    else {
        newFrame.size.height = viewSize.height - 10.0;
        newFrame.size.width = newFrame.size.height;
        newFrame.origin.y = 5.0f;
        newFrame.origin.x = centerPoint.x - (newFrame.size.width / 2.0f);
    }

    // Start animation
    UITextView * __weak captionTextView = _captionTextView;
    UIView * __weak imageCellView = _imageCellView;
    UIView * __weak backgroundView = _backgroundView;
    [UIView animateWithDuration: 0.25f delay: 0.0f options: UIViewAnimationOptionCurveEaseInOut animations: ^() {
        [backgroundView setAlpha: 0.8f];
        [imageCellView setFrame: newFrame];
    }
                     completion: ^(BOOL finished) {
                         [captionTextView setHidden: NO];
                     }];
}

- (void)viewDidAppear: (BOOL)animated
{
    [super viewDidAppear: animated];
    
    
}

#pragma mark - Tap GestureRecognizer Handler

- (void)handleTapGesture: (UITapGestureRecognizer *)tapGesture
{
    if ([tapGesture numberOfTapsRequired] == 2) {
        [_captionTextView setHidden: YES];

        // Start animation
        UIView * __weak imageCellView = _imageCellView;
        UIView * __weak backgroundView = _backgroundView;
        UIScrollView * __weak scrollView = _scrollView;
        
        [UIView animateWithDuration: 0.25f delay: 0.0f options: UIViewAnimationOptionCurveEaseInOut animations: ^() {
            [scrollView setZoomScale: 1.0f];
            [backgroundView setAlpha: 0.0f];
            [imageCellView setFrame: _startFrame];
        }
                         completion: ^(BOOL finished) {
                             if ([_delegate respondsToSelector: @selector(photoViewerDidFinish:)]) {
                                 [_delegate photoViewerDidFinish: self];
                             }
                             else {
                                 [[self view] removeFromSuperview];
                             }
                         }];
        
    }
    else
        [_captionTextView setHidden: ![_captionTextView isHidden]];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageCellView;
}

@end
