#import <UIKit/UIKit.h>

@protocol BNRPageControlDelegate;

@interface BNRPageControl : UIView

// Set these to control the PageControl.
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger numberOfPages;

// Customize these as well as the backgroundColor property.
@property (nonatomic, retain) UIColor *dotColorCurrentPage;
@property (nonatomic, retain) UIColor *dotColorOtherPage;

// Optional delegate for callbacks when user taps a page dot.
@property (nonatomic, weak) id<BNRPageControlDelegate> delegate;

@end

@protocol BNRPageControlDelegate<NSObject>
@optional
- (void)pageControlPageDidChange:(BNRPageControl *)pageControl;
@end