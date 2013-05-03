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

@interface BNRPhotoViewerViewController () <UIScrollViewDelegate, UIWebViewDelegate>
{
    __weak IBOutlet UIView *_backgroundView;
    __weak IBOutlet UIView *_captionBackgroundView;
    __weak IBOutlet UIView *_captionBackgroundView2;
    __weak IBOutlet UIView *_imageCellView;
    __weak IBOutlet UIImageView *_photoImageView;
    __weak IBOutlet UIWebView *_captionTextView;
    __weak IBOutlet UIScrollView *_scrollView;
    __weak IBOutlet UIButton *_closeButton;
    UIActivityIndicatorView *_activityIndicatorView;
    
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
    [[self view] addGestureRecognizer: tapGestureRecognizer];
    
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
        [_photoImageView setImage: [_photo thumbnail]];
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
    [_captionTextView loadHTMLString: [_photo caption] baseURL: [NSURL URLWithString: @"/"]];
    [_captionTextView setHidden: YES];
    
    [_captionBackgroundView2 setHidden: YES];
    [_captionBackgroundView2 setAlpha: 0.8f];
    
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
    [UIView animateWithDuration: 0.25f delay: 0.0f options: UIViewAnimationOptionCurveEaseInOut animations: ^() {
        [_backgroundView setAlpha: 0.8f];
        [_imageCellView setFrame: newFrame];
        [_captionBackgroundView setAlpha: 0.8f];
    }
                     completion: ^(BOOL finished) {
                         [_captionTextView setHidden: NO];
                     }];
}

#pragma mark - Actions

- (IBAction)close:(id)sender
{
    [_captionTextView setHidden: YES];
    [_closeButton setHidden: YES];
    
    // Start animation
    [UIView animateWithDuration: 0.25f delay: 0.0f options: UIViewAnimationOptionCurveEaseInOut animations: ^() {
        [_scrollView setZoomScale: 1.0f];
        [_backgroundView setAlpha: 0.0f];
        [_imageCellView setFrame: _startFrame];
        [_captionBackgroundView setAlpha: 0.0f];
        [_captionBackgroundView2 setAlpha: 0.0f];
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

#pragma mark - Tap GestureRecognizer Handler

- (void)handleTapGesture: (UITapGestureRecognizer *)tapGesture
{
    float finalAlpha = (_captionTextView.alpha == 0) ? 1 : 0;
    
    [_captionBackgroundView2 setHidden: [_captionBackgroundView isHidden]];
    [_captionBackgroundView setHidden: ![_captionBackgroundView2 isHidden]];
    
    [UIView animateWithDuration:0.1 animations:^{
        [_captionTextView setAlpha:finalAlpha];
        //[_captionBackgroundView setAlpha: finalBackgroundAlpha];
        //[_captionBackgroundView2 setAlpha: finalBackgroundAlpha2];
    }];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageCellView;
}

@end
