//
//  BNRPhotoViewerViewController.h
//  CountdownToZero
//
//  Created by Thomas Ward on 5/2/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRPhoto;
@class BNRPhotoViewerViewController;

@protocol BNRPhotoViewerDelegate <NSObject>

- (void)photoViewerDidFinish: (BNRPhotoViewerViewController *)photoViewer;

@end

@interface BNRPhotoViewerViewController : UIViewController

@property (nonatomic, weak) id<BNRPhotoViewerDelegate> delegate;

- (id)initWithPhoto: (BNRPhoto *)photo andPhotoFrame: (CGRect)frame;

@end
