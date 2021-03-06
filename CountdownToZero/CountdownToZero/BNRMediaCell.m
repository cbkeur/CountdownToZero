//
//  BNRMediaCell.m
//  CountdownToZero
//
//  Created by Thomas Ward on 5/2/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import "BNRMediaCell.h"
#import "BNRPhoto.h"
#import "BNRDataStore.h"

@interface BNRMediaCell ()
{
    UIImage *_image;
    UIImageView *_photoImageView;
    UIActivityIndicatorView *_activityIndicatorView;
}

@end

@implementation BNRMediaCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor: [UIColor carterRedColor]];
        
        CGRect imageFrame = CGRectMake(5.0f, 5.0f, frame.size.width - 10.0f, frame.size.height - 10.0f);
        _photoImageView = [[UIImageView alloc] initWithFrame: imageFrame];
        [_photoImageView setContentMode: UIViewContentModeScaleAspectFill];
        [_photoImageView setTranslatesAutoresizingMaskIntoConstraints: NO];
        [_photoImageView setClipsToBounds:YES];
        
        [[self contentView] addSubview: _photoImageView];
        
        // @"H:|-5-[a]-5-|"
        // @"V:|-5-[a]-5-|"
        
        [[self contentView] addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-2-[a]-2-|"
                                                                      options: 0
                                                                      metrics: nil
                                                                        views: @{@"a": _photoImageView}]];
        [[self contentView] addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"V:|-2-[a]-2-|"
                                                                      options: 0
                                                                      metrics: nil
                                                                        views: @{@"a": _photoImageView}]];
        
        CGRect activityIndicatorFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame: activityIndicatorFrame];
        [_activityIndicatorView setHidesWhenStopped: YES];
        [_activityIndicatorView startAnimating];
        [_activityIndicatorView setTranslatesAutoresizingMaskIntoConstraints: NO];
        [[self contentView] addSubview: _activityIndicatorView];
        
        [[self contentView] addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-5-[a]-5-|"
                                                                                    options: NSLayoutFormatAlignAllCenterX
                                                                                    metrics: nil
                                                                                      views: @{@"a": _activityIndicatorView}]];
        [[self contentView] addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"V:|-5-[a]-5-|"
                                                                                    options: NSLayoutFormatAlignAllCenterY
                                                                                    metrics: nil
                                                                                      views: @{@"a": _activityIndicatorView}]];
        
        
    }
    return self;
}

- (void)setPhoto:(BNRPhoto *)photo
{
    _photo = photo;
    
    if ([photo thumbnail]) {
        _image = [photo thumbnail];
        [_activityIndicatorView stopAnimating];
    }
    else {
        _image = nil;
        if ([photo thumbnailURL]) {
            [_activityIndicatorView startAnimating];
            UIActivityIndicatorView * __weak activityIndicatorView = _activityIndicatorView;
            UIImageView * __weak imageView = _photoImageView;
            [[BNRDataStore sharedStore] getPhotoThumbnail: photo WithCompletion: ^(NSData *data, NSError *err) {
                if (data) {
                    [activityIndicatorView stopAnimating];
                    UIImage *image = [UIImage imageWithData: data];
                    if (image) {
                        [imageView setImage: image];
                        [photo setThumbnail: image];
                    }
                }
            }];
        }
        
    }
    
    [_photoImageView setImage: _image];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
